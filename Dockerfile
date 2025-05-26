{
  "name": "TWRP A26x Build Environment",
  "build": {
    "dockerfile": "../Dockerfile",
    "context": ".."
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-vscode.cpptools",
        "redhat.vscode-yaml",
        "ms-azuretools.vscode-docker"
      ]
    }
  },
  "remoteUser": "root",
  "containerUser": "root",

  "postCreateCommand": [
    "echo 'Starting TWRP manifest and A26x device source setup...'",

    "repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni -b twrp-13.0 --depth=1",
    "repo sync -j$(nproc)",

    "echo 'Cloning A26x firmware dump from GitGud.io (containing device tree, kernel, platform)...'",
    "git clone https://gitgud.io/fw-dumps/samsung/a26x.git /tmp/a26x_fw_dump_temp",

    "echo 'Copying device-specific files...'",
    "mkdir -p device/samsung/a26x",
    "cp -r /tmp/a26x_fw_dump_temp/twrp-device-tree/samsung/a26x/* device/samsung/a26x/",

    "mkdir -p kernel/samsung/a26x",
    "cp -r /tmp/a26x_fw_dump_temp/kernel/* kernel/",
    "rm -rf kernel/samsung/a26x",

    "mkdir -p vendor/samsung/a26x",
    "cp -r /tmp/a26x_fw_dump_temp/vendor/* vendor/",
    "rm -rf vendor/samsung/a26x",

    "rm -rf /tmp/a26x_fw_dump_temp",

    "echo 'TWRP source setup complete! Ready for compilation.'"
  ]
}
