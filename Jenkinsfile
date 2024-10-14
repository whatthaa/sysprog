pipeline {
    agent any
    
    parameters {
        choice(name: 'PACKAGE_TYPE', choices: ['rpm', 'deb'], description: 'Choose package type to build and install')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('sysprog-image:latest')
                }
            }
        }
        
        stage('Build Package') {
            steps {
                script {
                    docker.image('sysprog-image:latest').inside('--entrypoint=""') {
                        sh 'mkdir -p build'
                        sh '''
                            cd build
                            mkdir -p sysprog_1.0-1/DEBIAN
                            echo "Package: sysprog" > sysprog_1.0-1/DEBIAN/control
                            echo "Version: 1.0-1" >> sysprog_1.0-1/DEBIAN/control
                            echo "Section: base" >> sysprog_1.0-1/DEBIAN/control
                            echo "Priority: optional" >> sysprog_1.0-1/DEBIAN/control
                            echo "Architecture: all" >> sysprog_1.0-1/DEBIAN/control
                            echo "Maintainer: Your Name <your.email@example.com>" >> sysprog_1.0-1/DEBIAN/control
                            echo "Description: Sample SysProg Package" >> sysprog_1.0-1/DEBIAN/control
                            mkdir -p sysprog_1.0-1/usr/local/bin
                            cp /usr/local/bin/count_files.sh sysprog_1.0-1/usr/local/bin/
                            dpkg-deb --build sysprog_1.0-1
                        '''
                        if (params.PACKAGE_TYPE == 'rpm') {
                            sh '''
                                cd build
                                alien -r --scripts sysprog_1.0-1.deb
                                ls -la
                                find . -name "*.rpm"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Install Package') {
            steps {
                script {
                    docker.image('sysprog-image:latest').inside('--entrypoint=""') {
                        if (params.PACKAGE_TYPE == 'rpm') {
                            sh '''
                                cd build
                                ls -la
                                RPM_FILE=$(find . -name "*.rpm")
                                if [ -n "$RPM_FILE" ]; then
                                    alien -i $RPM_FILE
                                else
                                    echo "RPM file not found"
                                    exit 1
                                fi
                            '''
                        } else {
                            sh '''
                                if [ -f ./build/sysprog_1.0-1.deb ]; then
                                    dpkg -i ./build/sysprog_1.0-1.deb
                                else
                                    echo "DEB file not found"
                                    exit 1
                                fi
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Execute Script') {
            steps {
                script {
                    docker.image('sysprog-image:latest').inside('--entrypoint=""') {
                        sh 'ls -la /usr/local/bin'
                        sh 'cat /usr/local/bin/count_files.sh'
                        sh '/usr/local/bin/count_files.sh'
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
