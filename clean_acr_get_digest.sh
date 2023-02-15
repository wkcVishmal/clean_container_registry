# Log in to Azure
# az login

# Set variables
registry_name="myreg"
repository_name="my_repo"
image_tag="1827"

# Get the image digest
image_digest=$(az acr repository show-manifests --name $registry_name --repository $repository_name --query "[?tags[0]=='$image_tag'].digest" -o tsv)

# Print the image digest
echo "Image digest: $image_digest"
