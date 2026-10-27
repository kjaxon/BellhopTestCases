# Double Seamount — BELLHOP3D Test Case

MATLAB scripts for the double seamount 3D test case (created by YT Lin), run with BELLHOP3D and the Acoustics Toolbox. Two overlapping conical seamounts rise from a flat seafloor, and the case looks at how sound from a source near them is focused and shadowed in 3D.

`DoubleSeamount.m` generates the bathymetry, then runs a ray trace and two transmission loss cases and plots the results.

## Requirements

- MATLAB
- Acoustics Toolbox MATLAB functions in `acoustictoolkit/`: `bellhop3d`, `writebdry3d`, `plotbdry3d`, `plotray3d`, `plotshdpol`
- A compiled BELLHOP3D binary in `bellhop/`
- These files in `env/`:

| Environment file             | Case                          |
|------------------------------|-------------------------------|
| `DoubleSeamount3D_ray.env`   | 3D ray trace                  |
| `DoubleSeamount3D.env`       | 3D transmission loss          |
| `DoubleSeamount3DHat.env`    | 3D transmission loss (second beam setup) |

No `.bty` file needs to be prepared in advance; `makebty.m` generates it. The sound speed profile is expected to be defined in the `.env` files, since no `.ssp` files are copied.

## Running

Open MATLAB, navigate into this folder, and run:

```matlab
DoubleSeamount
```

The script is split into sections (`%%`), so you can also run one part at a time with **Run Section**, after running the first section to set up paths and the bathymetry.

Model output (`.ray`, `.shd`, `.prt`) is written to `env/`. Saved figures are written to the **current MATLAB folder**:

| Figure file                  | Contents                                  |
|------------------------------|-------------------------------------------|
| `DoubleSeamount3D_ray.eps`   | Rays over the bathymetry                  |
| `3DGaussian.eps`             | TL plan view from `DoubleSeamount3D`      |
| `3DHat.png`                  | TL plan view from `DoubleSeamount3DHat`   |

## Folder layout

```
<root>/
├── setup_paths.m           Adds toolbox and binaries to the MATLAB path
├── DoubleSeamount.m        Main script: builds bathymetry, runs and plots all cases
├── makebty.m               Generates the double seamount bathymetry file
├── seamount_parameters.m   Position, height, slope and size of each seamount
├── sub_seamount.m          Computes depth on a grid from the seamount parameters
├── env/                    Environment files and model output
├── bellhop/                BELLHOP3D executables
└── acoustictoolkit/        Acoustics Toolbox MATLAB code (added recursively)
```

`setup_paths` creates `env/` if it is missing. The `bellhop/` and `acoustictoolkit/` folders must be supplied.

## Files

### `DoubleSeamount.m`

1. Sets up paths and sets the global `units` to `'km'`, which the Acoustics Toolbox plotting functions use for axis units.
2. Runs `makebty` to write `env/DoubleSeamount3D.bty`, and plots it (x 0–6 km, y −4 to 4 km).
3. **Ray trace:** runs `DoubleSeamount3D_ray` and draws the rays on the same figure (depth 0–900 m).
4. **Transmission loss:** runs `DoubleSeamount3D` and plots TL in plan view for a source at the origin and receivers at 400 m depth, color range 40–80 dB.
5. **Second transmission loss run:** copies the bathymetry to `DoubleSeamount3DHat.bty`, runs `DoubleSeamount3DHat`, and makes the same plot. The two runs differ only in their `.env` files; the figure names suggest Gaussian beams versus hat-shaped (geometric) beams. Both use the default beam spacing, about 300 beams in each direction.
6. Deletes the generated `DoubleSeamount3D.bty` and `DoubleSeamount3DHat.bty`.

### `makebty.m`

Script that builds the bathymetry and writes it to `env/DoubleSeamount3D.bty`.

| Setting        | Value                                                    |
|----------------|----------------------------------------------------------|
| Grid           | −8 to 8 km in x and y, 1000 × 1000 points (about 16 m spacing) |
| Depth          | From `sub_seamount`, using `seamount_parameters`          |
| Units          | x and y converted from m to km; depth in m                |
| Interpolation  | `'CS'`, passed to `writebdry3d`                           |

Because it is a script, it uses the `paths` variable from the workspace, so run `setup_paths` first (as `DoubleSeamount.m` does). It also leaves `btyfil` in the workspace, which `DoubleSeamount.m` uses for the bathymetry plot.

### `seamount_parameters.m`

Script that defines the `seamount` struct. Both seamounts are identical cones, side by side along y:

| Parameter | Seamount 1 | Seamount 2 | Meaning                          |
|-----------|------------|------------|----------------------------------|
| `tip_x`   | 3500 m     | 3500 m     | x position of the peak           |
| `tip_y`   | 1000 m     | −1000 m    | y position of the peak           |
| `tip_z`   | 200 m      | 200 m      | Depth of the peak                |
| `slope`   | 0.25       | 0.25       | Depth increase per meter from the peak (500/2000) |
| `radius`  | 2500 m     | 2500 m     | Base radius                      |

With these values, each cone reaches the flat seafloor at 825 m depth (200 + 0.25 × 2500). The peaks are 2 km apart, and the bases overlap.

### `sub_seamount.m`

```matlab
z = sub_seamount( seamount, X, Y );
```

Returns the depth at each point of `X` and `Y` (which must be the same size, such as from `meshgrid`). For each seamount, depth grows linearly with distance from the peak until the base radius, and stays flat beyond it. Where the seamounts overlap, the shallower of the two depths is used.

### `setup_paths.m`

```matlab
paths = setup_paths();
```

Returns a struct of folder locations, all relative to where `setup_paths.m` lives:

| Field        | Folder              |
|--------------|---------------------|
| `paths.root` | This folder         |
| `paths.env`  | `env/`              |
| `paths.bin`  | `bellhop/`          |
| `paths.at`   | `acoustictoolkit/`  |

It also adds `acoustictoolkit/` (with all subfolders) and `bellhop/` to the MATLAB path.

## Notes

- The ray trace case (`DoubleSeamount3D_ray`) has no matching `.bty` file. Only `DoubleSeamount3D.bty` and `DoubleSeamount3DHat.bty` are created, so if `DoubleSeamount3D_ray.env` reads its bathymetry from a file, copy `DoubleSeamount3D.bty` to `DoubleSeamount3D_ray.bty` before that run.
- `makebty.m` first builds a 0.5 m grid (32,001 points per side), then replaces it with the 1000 × 1000 grid. The first version is unused.