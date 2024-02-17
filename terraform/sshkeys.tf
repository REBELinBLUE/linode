resource "linode_sshkey" "onepassword" {
  label   = "1Password"
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgnlCD5hNitroeqHKun4svSkQwkt6OcWkTyA0g66Wj5"
}

resource "linode_sshkey" "ipad" {
  label   = "iPad Prompt App"
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTMpjcBBu6P2Arf5zF1kEOJJma5+SS9C87p0SqohTaUqo6XbQb/6cEtZmJy+9FlAQyCMRz+tsypbNE3PFkVUZFTehUWVBAY+oBmv8atQ4v+ar8m9RD+ZZvf/42pKOHo1fnLB4dCHb1W5YZM001KlFedNNczj89B2i0+NFLl9vHP09L9E07oE4hDXISCAm1qvDSoOCJfPZzLVZdQN9Ybw8k4zAbPKFchDXRDGl7N+sUbBCG/WnUyzgNKJcusxge14oktP/WkMK+DJWfCwG3kijnC2CxHkf3M+sgFJMe/y1+RWgHhcANZKenTYq2FuamELOfo1LRD0XlbK2fbfXaDCOp"
}

resource "linode_sshkey" "gpg" {
  label   = "GPG"
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5Q7TKWI+S+ni92soS9SFw902rUcflXku2Xg1ATnMjxoL3DSpV0FgZsilMP08eXy0jm9O1BwFwkGLjX69YsVvAiOhF5GLjUHXh/G0VZD8u05j0LkYh6mHOQEp9rFihRkrhQBRXGfNJiNY8NNUvTwrt7knnH/UUYYrC7eSc6U2nNAuvZitwo2XMmueAk7AayH2bI1LyI+DtgMeqr1H+mkO/Tf+uPv/4l8unhpK0G4O4uJWthG3+8J7xdro3yVGewEaos9pzDTK9sT4LVCSL9aZwW5B17EN+c14gt1e7uMlyZPkcAGFECW76SLXQwywGD65Sy7ceeu9f3uEtiLEBc5m1/aVbv2kIDKdokG7CB63k6OFregk16qVE+/ComcLHoE/EAVzee+8LnajxScu47cY0mHJrrS/DLPwuMChZD5Nb0OzPUJ/Z6xHlbJ7BAiPk6I64X29lWZxZ5JWit64OrhkXfRiD0AgmLoXQZOgNAnq358AafjFk9viVoMuEhQueBNB9QcnA302+yaYStYspoe6QnTmd3oZB6tycOtarGB6ni/hcVUUqjiqxY8We8dnk+hc0w4uTngTqlM7PIgwg/WXMC8hdFAgrJRFcPIV0Er6EV9vYIG14YS1k9fiRgPMrWBvQ6rRCxpQeBGWoLOaEF20Kv+7uBpdWrHvfc7puawK4ww=="
}

resource "linode_sshkey" "dropshare" {
  label   = "Dropshare"
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/WCQr/f60VrwHc/N3er381waX8OS+TEsVobNMLiizMcvxHUBYl6KiwkCKoUDQY1rEmCJkTQzw88eLN/G0GnTtEpenkYGorYoqiQAeDRrx9R368ORwTiVnUFt8Fx9Ux25tsBWulCiiQcHnsUxuY+h/XunMR1KxdKp9t7z23b1w3boo1lq8zhGXYIj+AdPRp7XrIcvr45ya95DlJqoYMCUy4bwy48EVgiRpPwVWInYVZhM7Wq+bHKABEUcIS3NhL4tNmD/+UkjC4sO8c/jVorL4no7EIpQ1w/eOhMjAVpSd6k+cke+39/pyx62nUxDCzhk+NAHN+jkHnWwpmiLNOFat"
}
