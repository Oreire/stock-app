# stock-app
Infrastructure provisioning using GitHub Actions

To be extended to deploy Ansible playbooks and Docker compose

Later updates for the provisioning of containerized applicayions would be implemented.

How can I fix the problem of commiting and pushing to GitHub from vscode?

name: Deploy Ansible Playbook

on:
  push:
    branches:
      - main

env:
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY_ID }}
  AWS_DEFAULT_REGION: "eu-west-2"

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Install Ansible
        run: |
          python -m pip install --upgrade pip
          pip install ansible

      - name: Setup SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts

      - name: Start SSH Agent
        uses: webfactory/ssh-agent@v0.5.3
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Run Ansible Playbook
        if: github.ref == 'refs/heads/main'
        run: ansible-playbook /ansibleplay/manage.yml
        env:
          ANSIBLE_HOST_KEY_CHECKING: 'false'

