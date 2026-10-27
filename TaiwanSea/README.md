# Taiwan — BELLHOP3D Test Cases

MATLAB scripts for Michael Porter's Taiwan 3D test cases (mbp, 2011; updated by Khalil Jackson, 2026), set up to run with BELLHOPCUDA and the Acoustics Toolbox. The test case models sound propagation over real ETOPO1 bathymetry around Taiwan and compares two ways of handling 3D bathymetry:

- **Nx2D**: a fan of independent 2D vertical slices, one per bearing. Faster, but ignores sound bending out of each slice.
- **Full 3D**: rays can travel and refract in any direction.

`TaiwanSea.m` plots the bathymetry and 3D sound speed field, then runs transmission loss and ray trace cases in both modes.

## Requirements

- MATLAB
- Acoustics Toolbox MATLAB functions in `acoustictoolkit/`: `bellhop3d`, `bellhopnx2d`, `plotbdry3d`, `plotssp3d`, `plotshd`, `plotshdpol`, `caxisrev`, `plotray3d` (and `LoadBathymetry` and `writebdry3d` if regenerating the bathymetry)
- These files in `env/`:
  - `Taiwan.bty`: shared bathymetry
  - `Taiwan.ssp`: shared 3D sound speed field
  - One `.env` file per case:

| Environment file          | Case                     |
|---------------------------|--------------------------|
| `TaiwanNx2D.env`          | Nx2D transmission loss   |
| `Taiwan3D.env`            | 3D transmission loss     |
| `TaiwanNx2D_ray.env`      | Nx2D ray trace           |
| `Taiwan3D_ray.env`        | 3D ray trace             |

## Running

Open MATLAB, navigate into this folder, and run:

```matlab
TaiwanSea
```

This runs all four cases in order. The script is split into sections (`%%`), so you can also run a single case with **Run Section**, after running the first section to set up paths and the colormap.

Model output (`.shd`, `.ray`, `.prt`) is written to `env/`. Saved figures are written to the **current MATLAB folder**:

| Figure file           | Contents                          |
|-----------------------|-----------------------------------|
| `TaiwanSSP.png`       | 3D sound speed field              |
| `Taiwan3DTL.eps`      | 3D TL, polar view                 |
| `Taiwan3D_side.eps`   | 3D TL, side view                  |
| `TaiwanNx2D_ray.eps`  | Nx2D rays over the bathymetry     |
| `Taiwan3D_ray.eps`    | 3D rays over the bathymetry       |

The Nx2D transmission loss figures are displayed but not saved.

## Folder layout

```
<root>/
├── setup_paths.m        Adds toolbox and binaries to the MATLAB path
├── TaiwanSea.m          Main script: plots inputs, runs and plots all four cases
├── prep_envfiles.m      Copies the shared .bty/.ssp to match a case name
├── env/                 Environment files and model output
├── bellhop/             BELLHOP executables
└── acoustictoolkit/     Acoustics Toolbox MATLAB code (added recursively)
```

`setup_paths` creates `env/` if it is missing. The `bellhopcuda/` and `acoustictoolkit/` folders must be supplied.

## Files

### `TaiwanSea.m`

**Setup and input plots**

1. Sets up paths and sets the global `units` to `'km'`, which the Acoustics Toolbox plotting functions use for axis units.
2. Plots `env/Taiwan.bty` with an ocean/land colormap (copper for land, reversed jet for ocean), color range ±7500 m.
3. Plots the 3D sound speed field from `env/Taiwan.ssp`, color range 1510–1535 m/s, and saves it as `TaiwanSSP.png`.

**Model runs**

Each case:

1. Copies the shared bathymetry and sound speed field to the case's name with `prep_envfiles`.
2. Runs `bellhopnx2d` or `bellhop3d`.
3. Plots (and for most cases saves) the result.
4. Deletes the copied `.bty` and `.ssp` files, leaving only the shared originals.

`caxisrev` reverses the color scale so lower transmission loss (louder) shows as the stronger color.

**Regenerating the bathymetry**

Two commented-out lines near the top rebuild `Taiwan.bty` from an ETOPO1 export:

```matlab
Bathy = LoadBathymetry( 'Taiwan.xyz' );   % load the xyz file from ETOPO1
writebdry3d( 'Taiwan.bty', Bathy );        % save it in .bty format
```

These read and write in the current MATLAB folder, so move the result into `env/` or use `fullfile( paths.env, 'Taiwan.bty' )`. This was written by Mike wasn't sure if it should be removed.

### `prep_envfiles.m`

```matlab
fileroot = prep_envfiles( paths, caseName );
```

BELLHOP expects the `.env`, `.bty` and `.ssp` files to share one base name. This function copies `env/Taiwan.bty` and `env/Taiwan.ssp` to `env/<caseName>.bty` and `env/<caseName>.ssp`, and returns the full path without an extension (`env/<caseName>`), ready to pass to the model.

### `setup_paths.m`

```matlab
paths = setup_paths();
```

Returns a struct of folder locations, all relative to where `setup_paths.m` lives:

| Field        | Folder              |
|--------------|---------------------|
| `paths.root` | This folder         |
| `paths.env`  | `env/`              |
| `paths.bin`  | `bellhopcuda/`      |
| `paths.at`   | `acoustictoolkit/`  |

It also adds `acoustictoolkit/` (with all subfolders) and `bellhopcuda/` to the MATLAB path.
