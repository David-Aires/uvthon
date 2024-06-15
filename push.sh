#!/bin/bash

# Nom d'utilisateur Docker Hub et nom du dépôt
DOCKER_USER="ajaxox"
DOCKER_REPO="uvthon"

docker buildx create --use --platform=linux/amd64,linux/arm64,linux/arm/v7 --name multi-platform-builder

# Fonction pour construire et pousser les images Docker pour chaque plateforme
build_and_push() {
    local version=$1
    local os=$2

    # Créer le nom de l'image Docker
    local image_name="${DOCKER_USER}/${DOCKER_REPO}:${version}-${os}"

    # Construire l'image Docker pour les plateformes arm64 et amd64
    docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v7  -t "${image_name}" "${version}/${os}" --push
}

# Rechercher les dossiers de version
for version_dir in */; do
    version=$(basename "${version_dir}")

    # Rechercher les dossiers d'OS dans chaque dossier de version
    for os_dir in "${version_dir}"*/; do
        os=$(basename "${os_dir}")

        # Appeler la fonction pour construire et pousser les images
        build_and_push "${version}" "${os}"
    done
done

echo "All images are build and push to registry."
