# New England Seamount (NESMA) — BELLHOP3D Test Case

MATLAB scripts for running 3D acoustic propagation models of the New England Seamount area using BELLHOP3D and Michael Porter's Acoustics Toolbox. The folder has two workflows:

- **Eigenray plot** (`NESMA_Eigen.m`): traces rays over a pre-made seamount bathymetry and plots them in 3D.
- **Transmission loss** (`NESMA_TLoss.m`): builds a bathymetry file from high-resolution survey data, runs BELLHOP3D, and plots a transmission loss slice over the 3D seafloor.

## Requirements

- MATLAB
- Acoustics Toolbox MATLAB functions (`bellhop3d`, `read_shd`, `readbdry3d`, `plotbdry3d`, `plotray3d`) in `acoustictoolkit/`
- A compiled BELLHOP3D binary in `bellhop/`
- NESMA_RR2409_bathy_25m file [download link](https://drive.google.com/file/d/18E9dFyUA-nb3en8ZNd6JojhD327lIYtl/view?usp=drive_link)


## Running

Open MATLAB, navigate into this directory, then run either script:

```matlab
NESMA_Eigen
NESMA_TLoss
```

## Folder layout

```
<root>/
├── setup_paths.m        Adds toolbox and binaries to the MATLAB path
├── prep_envfiles.m      Copies shared .bty/.ssp files to match a case name
├── NESMA_Eigen.m        Eigenray script
├── NESMA_TLoss.m        Transmission loss script
├── NESMA_RR2409_bathy_25m.mat   <- Needs to be downloaded from google drive and added
├── env/                 Environment files (.env, .bty, .ssp) and model output
├── bellhop/             BELLHOP executables
└── acoustictoolkit/     Acoustics Toolbox MATLAB code (added recursively)
```

`setup_paths` creates `env/` if it is missing. The `bellhop/` and `acoustictoolkit/` folders must be supplied.

## Files

### `setup_paths.m`

```matlab
paths = setup_paths();
```

Returns a struct of folder locations, all relative to where `setup_paths.m` lives, so the scripts work no matter which folder MATLAB is in:

| Field        | Folder              |
|--------------|---------------------|
| `paths.root` | This folder         |
| `paths.env`  | `env/`              |
| `paths.bin`  | `bellhop/`          |
| `paths.at`   | `acoustictoolkit/`  |

It also adds `acoustictoolkit/` (with all subfolders) and `bellhop/` to the MATLAB path.

### `prep_envfiles.m`

```matlab
fileroot = prep_envfiles( paths, caseName );
```

BELLHOP3D expects the `.env`, `.bty` and `.ssp` files to share one base name. This function copies the shared files `env/seamount.bty` and `env/NESMA.ssp` to `env/<caseName>.bty` and `env/<caseName>.ssp`, and returns the full path without an extension (`env/<caseName>`), ready to pass to `bellhop3d`.

### `NESMA_Eigen.m`

Plots eigenrays over the seamount ("TR & Sam Mooring").

1. Sets up paths.
2. Copies the shared bathymetry and sound speed profile to `env/NESMA_eigen.*`.
3. Runs BELLHOP3D.
4. Plots the bathymetry (`plotbdry3d`) with the rays on top (`plotray3d`).
5. Deletes the copied `.bty` and `.ssp` files so only the shared originals remain.

**Needs in `env/`:** `NESMA_eigen.env` (set to a ray run type), `seamount.bty`, `NESMA.ssp`.

### `NESMA_TLoss.m`

Computes and plots transmission loss over the seamount.

1. Loads `NESMA_RR2409_bathy_25m.mat` (variables `lor`, `lar`, `zr`). The bathymetry is kept in the workspace between runs, so it is only loaded the first time.
2. Writes `env/NESMA_TLoss.bty` from the grid:
   - Cropped to 68.0°W to 61.0°W, 36.5°N to 40.5°N (this can be adjusted)
   - Subsampled by 10 (25 m to about 250 m spacing)
   - Converted to km relative to the source at **64.0°W, 38.3°N**
3. Runs BELLHOP3D.
4. Reads the bathymetry and the shade (`.shd`) output.
5. Plots a transmission loss slice (color range 50 to 120 dB) over the 3D seafloor, viewed from azimuth −45°, elevation 25°.
6. Relabels the axes from km back to longitude, latitude and depth in meters, using a flat-earth conversion around the source (Earth radius 6371 km). Depth is shown from 1000 to 6000 m.

**Needs in `env/`:** `NESMA_TLoss.env` (set to a coherent or incoherent TL run type), plus a sound speed profile if the `.env` file refers to one. The script writes its own `.bty` file.


`NESMA_TLoss` loads the bathymetry file from the current folder, so run it from this folder. Large grids can take a while to write and run; increase `'Subsample'` for quicker test runs.

## Notes

- Outputs (`.ray`, `.shd`, `.prt`) are written to `env/` next to the input files.
- The comment in `prep_envfiles.m` mentions "KoreanSea"; it is left over from an earlier case. The function actually uses `seamount.bty` and `NESMA.ssp`.
- The TL script's source position (`src_lon`, `src_lat`) must match the source location in `NESMA_TLoss.env`, or the axis labels will be offset.