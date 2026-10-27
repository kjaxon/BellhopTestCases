# Korean Sea — BELLHOP3D Test Cases

MATLAB scripts for Michael Porter's Korean Sea 3D test cases (mbp, 2011), set up to run with BELLHOPCUDA and the Acoustics Toolbox. The test case models sound propagation over an idealized seamount and compares two ways of handling 3D bathymetry:

- **Nx2D**: a fan of independent 2D vertical slices, one per bearing. Faster, but ignores sound bending out of each slice.
- **Full 3D**: rays can travel and refract in any direction.

`KoreanSea.m` runs transmission loss, ray trace and eigenray cases in both modes and plots the results.

## Requirements

- MATLAB
- Acoustics Toolbox MATLAB functions in `acoustictoolkit/`: `bellhop3d`, `bellhopnx2d`, `writebdry3d`, `plotshd`, `plotshdpol`, `caxisrev`, `plotbdry3d`, `plotray3d`
- BELLHOPCUDA executables in `bellhopcuda/`, for the C++ build, the CUDA build, or both (Windows builds end in `.exe`). For Nx2D runs these are `bellhopcxxnx2d` (C++) and `bellhopcudanx2d` (CUDA). This is the only test case with bellhopcuda pre installed.
- These files in `env/`:
  - `KoreanSea.bty`: shared seamount bathymetry (can be generated with `makebty.m`)
  - `KoreanSea.ssp`: shared sound speed profile
  - One `.env` file per case:

| Environment file             | Case                       |
|------------------------------|----------------------------|
| `KoreanSea_Nx2D.env`         | Nx2D transmission loss     |
| `KoreanSea_3D.env`           | 3D transmission loss       |
| `KoreanSea_Nx2D_ray.env`     | Nx2D ray trace             |
| `KoreanSea_3D_ray.env`       | 3D ray trace               |
| `KoreanSea_3D_eigen.env`     | 3D eigenrays               |

## Running

Open MATLAB, navigate into this folder, and run:

```matlab
KoreanSea
```

This runs all five cases in order. The script is split into sections (`%%`), so you can also run a single case with **Run Section**, after running the first section to set up paths.

**The 3D eigenray case may take awhile.** Skip or comment out the last section unless you need it.

Each case writes its output to `env/`:

| Output        | Produced by          |
|---------------|----------------------|
| `.shd`        | Transmission loss cases |
| `.ray`        | Ray trace and eigenray cases |
| `.prt`        | Every case (run log) |

## Folder layout

```
<root>/
├── setup_paths.m        Adds toolbox and binaries to the MATLAB path
├── KoreanSea.m          Main script: runs and plots all five cases
├── prep_envfiles.m      Copies the shared .bty/.ssp to match a case name
├── makebty.m            Generates the seamount bathymetry file
├── env/                 Environment files and model output
├── bellhopcuda/         BELLHOPCUDA executables
└── acoustictoolkit/     Acoustics Toolbox MATLAB code (added recursively)
```

`setup_paths` creates `env/` if it is missing. The `bellhopcuda/` and `acoustictoolkit/` folders must be supplied.

## Files

### `KoreanSea.m`

Sets up paths and sets the global `units` to `'km'`, which the Acoustics Toolbox plotting functions use for axis units. It then runs each case the same way:

1. Copies the shared bathymetry and sound speed profile to the case's name with `prep_envfiles`.
2. Runs `bellhopnx2d` or `bellhop3d`.
3. Plots the result.
4. Deletes the copied `.bty` and `.ssp` files, leaving only the shared originals.


`caxisrev` reverses the color scale so lower transmission loss (louder) shows as the stronger color.

The bathymetry line `makebty` near the top is commented out. Uncomment it to regenerate the bathymetry before running.

### `prep_envfiles.m`

```matlab
fileroot = prep_envfiles( paths, caseName );
```

BELLHOP expects the `.env`, `.bty` and `.ssp` files to share one base name. This function copies `env/KoreanSea.bty` and `env/KoreanSea.ssp` to `env/<caseName>.bty` and `env/<caseName>.ssp`, and returns the full path without an extension (`env/<caseName>`), ready to pass to the model.

### `makebty.m`

Script that writes `KoreanSea.bty`, an idealized seamount:

| Setting        | Value                                              |
|----------------|----------------------------------------------------|
| Grid           | −100 to 100 km in x and y, 41 × 41 points (5 km spacing) |
| Background depth | 5000 m                                           |
| Seamount       | Rises 2000 m (peak at 3000 m depth), centered at x = 30 km, y = 30 km |
| Shape          | `5000 − 2000 / (1 + r² / 20²)`, where r is the distance in km from the center |

The file is written with `writebdry3d`.

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

## Notes

- `makebty.m` sets `interp_type` (`'R'`, then `'C'`), but the variable isn't passed to `writebdry3d`, so it has no effect.
- The second argument to `bellhop3d` / `bellhopnx2d` picks which build of BELLHOPCUDA runs: `0` for C++, `1` for CUDA. `KoreanSea.m` passes `0` everywhere, so it runs the C++ build. The wrapper picks the `.exe` version on Windows and the plain executable on Linux, and stops with an error if the chosen executable isn't in `bellhopcuda/`.