# RHEL9 Vagrant Setup

This Vagrant configuration sets up a Red Hat Enterprise Linux 9 virtual machine using Hyper-V.

## Prerequisites

- Vagrant installed
- Hyper-V enabled on Windows
- Red Hat subscription account

## Setup

1. Clone or download this Vagrantfile
2. Create a `.env` file in the same directory with your Red Hat credentials:

```bash
RHEL_USERNAME=your_username
RHEL_PASSWORD=your_password
```

3. Load the environment variables:

**Linux/Mac:**
```bash
source .env
```

**Windows (PowerShell):**
```powershell
Get-Content .env | ForEach-Object { $name, $value = $_.split('='); Set-Item -Path "env:$name" -Value $value }
```

**Alternative: Use dotenv tool**
```bash
# Install dotenv-cli globally
npm install -g dotenv-cli

# Run vagrant with dotenv
dotenv vagrant up
```

4. Start the VM:

```bash
vagrant up
```

## Configuration

- **Provider**: Hyper-V
- **CPUs**: 4
- **Memory**: 4096 MB
- **Network**: Public network (bridged)
- **Hostname**: rhel9

## What gets installed/configured

- Red Hat subscription registration
- vim editor
- SSH password authentication enabled
- Firewall disabled

## Environment Variables

The following environment variables must be loaded before running `vagrant up`:

- `RHEL_USERNAME`: Your Red Hat subscription username
- `RHEL_PASSWORD`: Your Red Hat subscription password

## Security Note

Never commit the `.env` file to version control. Add it to your `.gitignore`:

```
.env
.vagrant/
```
