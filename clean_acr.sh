#!/bin/bash

# Set variables
registry_name="myreg"
repository_name="my_repo"
num_images_to_keep=2

# Log in to Azure
az login

# Get the list of all images in the repository
all_images=$(az acr repository show-manifests --name $registry_name --repository $repository_name --orderby time_desc --query "[].digest" -o tsv)

# Get the list of images to delete
images_to_delete=$(echo "$all_images" | tail -n +$(($num_images_to_keep + 1)))

# Loop through the list of images and delete them
for digest in $images_to_delete
do
  echo "Deleting image with digest: $digest"
  az acr repository delete --name $registry_name --image $repository_name@$digest --yes
done
