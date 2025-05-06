# Packer Proxmox Templates

This project provides Packer templates for creating Proxmox virtual machine (VM) templates for various Linux distributions.

## Prerequisites

- [Packer](https://www.packer.io/downloads) installed on your system
- Access to a Proxmox VE server with API permissions
- ISO images of the supported operating systems uploaded to your Proxmox storage

## Project Structure

```
├── Makefile                  # Contains build commands for all templates
├── variables.pkrvars.hcl     # Common variables for all templates
├── almalinux8/               # AlmaLinux 8 template files
│   ├── almalinux-8-x86_64.pkr.hcl
│   └── http/
│       └── inst.ks.pkrtpl.hcl
├── almalinux9/               # AlmaLinux 9 template files
│   ├── almalinux-9-x86_64.pkr.hcl
│   └── http/
│       └── inst.ks.pkrtpl.hcl
├── ubuntu2204/               # Ubuntu 22.04 template files
│   ├── ubuntu-22.04.pkr.hcl
│   ├── files/
│   │   └── 99-pve.cfg
│   └── http/
│       ├── meta-data
│       └── user-data.pkrtpl.hcl
└── ubuntu2404/               # Ubuntu 24.04 template files
    ├── ubuntu-24.04.pkr.hcl
    ├── files/
    │   └── 99-pve.cfg
    └── http/
        ├── meta-data
        └── user-data.pkrtpl.hcl
```

## Configuration

The `variables.pkrvars.hcl` file contains variables that need to be configured before running Packer:

| Variable | Description | Example |
|----------|-------------|---------|
| `proxmox_api_url` | URL of your Proxmox API | `https://proxmox.example.com:8006/api2/json` |
| `proxmox_api_token_id` | Your Proxmox API token ID | `user@pam!token_name` |
| `proxmox_api_token_secret` | Your Proxmox API token secret | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `proxmox_node` | Proxmox node to build the template on | `pve` |
| `root_password` | Password for the root user | `StrongPassword123!` |
| `timezone` | Timezone for the VMs | `Europe/London` |
| `ssh_public_key` | SSH public key to install on the VMs | `ssh-rsa AAAA...` |
| `vm_cores` | Number of CPU cores | `2` |
| `vm_memory` | Amount of RAM in MB | `2048` |
| `vm_disk_size` | Disk size | `10G` |
| `vm_storage_pool` | Proxmox storage pool for VM disks | `local-lvm` |
| `vm_disk_format` | Disk format | `raw` or `qcow2` |
| `iso_storage_pool` | Proxmox storage pool for ISOs | `local` |
| `almalinux8_iso` | Path to AlmaLinux 8 ISO | `local:iso/AlmaLinux-8-x86_64-minimal.iso` |
| `almalinux9_iso` | Path to AlmaLinux 9 ISO | `local:iso/AlmaLinux-9-x86_64-minimal.iso` |
| `ubuntu2204_iso` | Path to Ubuntu 22.04 ISO | `local:iso/ubuntu-22.04-live-server-amd64.iso` |
| `ubuntu2404_iso` | Path to Ubuntu 24.04 ISO | `local:iso/ubuntu-24.04-live-server-amd64.iso` |

**Important:** Before running the templates:
1. Ensure you've replaced the placeholder values in `variables.pkrvars.hcl` with your actual Proxmox settings
2. Verify that you've uploaded the necessary ISO files to your Proxmox server
3. Make sure your Proxmox user has sufficient permissions to create VMs and templates

## Usage

1. **Clone this repository:**
   ```bash
   git clone <repository_url>
   cd packer-proxmox-templates
   ```

2. **Configure variables:**
   Edit `variables.pkrvars.hcl` with your Proxmox environment details and desired VM specifications.

3. **Build templates:**
   Use the `Makefile` to build specific templates or all templates.

   * Build a specific template (e.g., Ubuntu 24.04):
     ```bash
     make ubuntu2404
     ```
   
   * Build all templates:
     ```bash
     make all
     ```
   
   * Validate a specific template:
     ```bash
     make validate-ubuntu2404
     ```
   
   * Validate all templates:
     ```bash
     make validate-all
     ```

   Alternatively, run Packer commands directly:
   ```bash
   packer build -var-file="variables.pkrvars.hcl" ubuntu2404/ubuntu-24.04.pkr.hcl
   ```

## Supported Operating Systems

| Distribution | Version | Template Directory | Make Command |
|-------------|---------|-------------------|-------------|
| AlmaLinux   | 8       | `almalinux8`      | `make almalinux8` |
| AlmaLinux   | 9       | `almalinux9`      | `make almalinux9` |
| Ubuntu      | 22.04 LTS | `ubuntu2204`    | `make ubuntu2204` |
| Ubuntu      | 24.04 LTS | `ubuntu2404`    | `make ubuntu2404` |

## After Template Creation

Once your templates are created in Proxmox:

1. They will appear in your Proxmox GUI as VM templates
2. You can clone them to create new VMs quickly
3. Each template is preconfigured with SSH access using the public key provided

## Troubleshooting

* If a build fails, check the Packer logs for detailed error messages
* Ensure your Proxmox API token has sufficient permissions
* Verify that the ISO files are properly accessible in the specified storage pool
* Check that the network settings match your Proxmox environment

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is open source and available under the [MIT License](LICENSE).
