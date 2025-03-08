# stock-app
Infrastructure provisioning using GitHub Actions

To be extended to deploy Ansible playbooks and Docker compose

Later updates for the provisioning of containerized applicayions would be implemented.

How can I fix the problem of commiting and pushing to GitHub from vscode?

Updates to Private key on GitHub



---
- hosts: stock_servers
  become: yes
  gather_facts: true
  tasks:
    - name: Update all packages (Amazon Linux)
      ansible.builtin.yum:
        name: '*'
        state: latest
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Install Git (Amazon Linux)
      ansible.builtin.yum:
        name: git
        state: present
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Install tree (Amazon Linux)
      ansible.builtin.yum:
        name: tree
        state: present
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Install pip (Amazon Linux)
      ansible.builtin.yum:
        name: python3-pip
        state: present
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Downgrade docker package
      ansible.builtin.pip:
        name: docker==6.1.3
        state: present

    - name: Clone Git repository
      ansible.builtin.git:
        repo: 'https://github.com/Oreire/stock-price-app.git'
        dest: /home/{{ ansible_env.HOME }}/stock-price-app
        version: 'main'

    - name: Ensure Docker is installed (Amazon Linux)
      ansible.builtin.yum:
        name: docker
        state: present
      when: ansible_facts['distribution'] in ['Amazon']
    
    - name: Start Docker service
      ansible.builtin.service:
        name: docker
        state: started
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Ensure Docker Compose is installed
      ansible.builtin.pip:
        name: docker-compose
        extra_args: --ignore-installed requests
        state: present
      when: ansible_facts['distribution'] in ['Amazon']

    - name: Export Docker environment variables
      ansible.builtin.shell: |
        export DOCKER_API_VERSION=1.41
        export DOCKER_HOST=unix:///var/run/docker.sock
        export DOCKER_TLS_VERIFY=1
        export DOCKER_CERT_PATH=/etc/docker

    - name: Start services using Docker Compose
      ansible.builtin.command:
        cmd: docker-compose up -d --build --force-recreate
        chdir: /home/{{ ansible_env.HOME }}/stock-price-app

