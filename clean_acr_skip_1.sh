#!/bin/bash

# Set variables
registry_name="myreg"
repository_name="my_repo"
image_tag="v0_9"

image_to_keep_digest=$(az acr repository show-manifests --name $registry_name --repository $repository_name --query "[?tags[0]=='$image_tag'].digest" -o tsv)

if [ -z "$image_to_keep_digest" ]
then
    echo "Error: Image with tag '$image_tag' not found in repository '$repository_name' in registry '$registry_name'."
    exit 1
fi
# Log in to Azure
# az login

# Get the list of all images in the repository
all_images=$(az acr repository show-manifests --name $registry_name --repository $repository_name --orderby time_desc --query "[].digest" -o tsv)

# Loop through the list of images and delete them, except for the image to keep
for digest in $all_images
do
  if [ "$digest" != "$image_to_keep_digest" ]
  then
    echo "Deleting image with digest: $digest"
    az acr repository delete --name $registry_name --image $repository_name@$digest --yes
  else
    echo "Skipping image with digest: $digest"
  fi
done