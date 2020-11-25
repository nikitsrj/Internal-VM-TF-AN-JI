DBMATCH = 'unknown'
pipeline {
   agent any
   stages {
      stage('Checkout') {
         steps {
            echo "Checking out Code Templates"
            git branch: 'main', credentialsId: 'github-cred', url: 'https://github.com/nikitsrj/Internal-VM-TF-AN-JI.git'
         }
      }
      stage('upload'){
          steps{
              script {
            // Uploads file via master node and stases it for other nodes to access
            def inputFile = input message: 'Upload file', parameters: [file(name: "serv.json")]
            new hudson.FilePath(new File("${workspace}/smbc/serv.json")).copyFrom(inputFile)
            inputFile.delete()
              }
          }
       }
      stage('PreProvision'){
          steps{
              sh '''cd ${WORKSPACE}/smbc
                    bash -x arrayhost.sh
                    yq r --prettyPrint serv.json > tfgenerate/vars/vmtfvars.yaml'''
          }
      }
      stage('Terraform Template Generation'){
          steps{
              sh '''cd ${WORKSPACE}/smbc
                    ansible-playbook tfgenerate.yaml -i localhost -vvv
                    cp tfgenerate/files/main.tf .
                    sleep 5 '''
          }
      }
      stage('Template and Vsphere Resource Validation'){
          steps{
              sh '''cd ${WORKSPACE}/smbc
                    terraform init
                    terraform plan -out=tfplan '''
          }
      }
      stage('VM Provisioning In Process'){
          steps{
              sh ''' cd ${WORKSPACE}/smbc
                     echo VM Provisioning is in Process
                     terraform apply "tfplan" '''
          }
      }
      stage ('DBCondition'){
          steps{
              echo "${DBMATCH}"
              script{
                  DBMATCH = sh(returnStdout: true, script: 'cd smbc && bash -x dbcondition.sh').trim()
              }
              echo "${DBMATCH}"
          }
      }
      
      stage ('DB Installation Pause stage') {
        when { 
            expression { DBMATCH != "NO" }
         }
         steps {
         sh ''' figlet DB INSTALL PAUSE '''
         input message: 'Need To install the DB, Once Done pls Aprrove. Have You Installed the DB ???'
         echo "Proceeding with step..."
        }
      }
      stage ('Tenable Report scanning') {
          steps {
              echo "Report scanning in progress"
          }
      }
      stage ('ELK Push') {
          steps {
              echo "DATA getting pushed to Elasticsearch Serv_Inventory Index"
              sh '''cd ${WORKSPACE}/smbc
                    cat serv.json | jq -c '.server_details[] | {"index": {"_index": "vminventory", "_type": "vms", "_id": .id}}, .' | curl -XPOST -H "Content-Type: application/json" localhost:9200/_bulk --data-binary @- '''
              
          }
      }
   }
   post { 
        always { 
            cleanWs()
        }
    }
}
