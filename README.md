# maap-publish-stac

Minimal MAAP DPS algorithm that copies a prepared, self-contained STAC catalog
into the job's `output/` directory, which triggers ingestion into the internal
DPS STAC (`dps-stac.maap-project.org`).

Register with build command `publish_stac/build-env.sh`, run command
`publish_stac/run_publish.sh`, and one positional input `catalog_s3` (an
`s3://` folder holding `catalog.json`).

Used to publish the Prithvi-EO-2.0 circumboreal AGBD and canopy height
collections (`prithvi_boreal_{agb,ht}_2020` items).
