### Prerequisites

- A Google Cloud Platform account, preferably with free credits ($300 for new users)
- A terminal of some kind (I used Windows Subsystem for Linux)
- Terraform installed in said terminal
- google-cloud-cli installed and authenticated in said terminal
- **Awareness that this will cost you around $100/month as configured**

### Deployment

0. Enable GCP Compute Engine API in the GCP Console
1. Clone this repo
2. cd to repo
3. Create/modify `terraform_boilerplate.tfvars` to reflect your `project_id`, `region`, and `zone` and rename to `terraform.tfvars`
3. terraform init
4. terraform plan
5. terraform apply
6. Wait approximately 15 minutes
7. Go to the GCE instance in Google Cloud and connect to IP_ADDRESS:8211 in Palworld

### Modification of Server

1. SSH via browser to GCE instance
2. `sudo -u steam -s`

#### To shutdown server:

1. `screen -ls`
2. Note the output and `screen -r <output from above>`
2. `CTRL+C`

#### To modify server settings:

1. `cd /home/steam/.steam/SteamApps/common/PalServer/`
2. `cp DefaultPalWorldSettings.ini Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`
3. `nano Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`

#### To re-run server after modification of PalWorldSettings.ini:

`screen -dmS palworld-running ./PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS`

### Resources

- https://github.com/A1RM4X/HowTo-Palworld
- ChatGPT