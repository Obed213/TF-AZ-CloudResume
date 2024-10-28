# Needed for CI/CD with GitHub Actions > Repository Secrets.
# Replace <Subscription ID> with your Subscription ID
# This will output data, make sure to copy that and add it into the GitHub Actions Repository Secrets.
# https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-static-site-github-actions?tabs=userlevel
az ad sp create-for-rbac --name "SP-GitHub-ObedResume" --role contributor --scopes /subscriptions/<Subscription ID>/resourceGroups/RG-TF-AzureResume-Obed --sdk-auth