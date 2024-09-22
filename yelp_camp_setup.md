step 1:
  git clone < project>
  cd scripts
  ./cicd-deploy.sh
  ./gcp-infra.sh &

step 2: env variable
  - create mopbox token
  - mogodb atlas url
  - cloudinary api configuration
  
step 3: Jenkins
  Jenkins: login jenkins web ui:
  install plugins:
  - nodejs
  - sonarqube
  - docker
  - pipeline
  - kubernetes, cli 
  cred & configuration:
  - add docker cred 
  - add sonarqube cred and configure
  - github cred for private registry
  - add service accpint file for gke auth
  - create key for jenkins-service-account:
      gcloud iam service-accounts keys create ~/jenkins-sa-key.json \
      --iam-account=jenkins-sa@praks-dev.iam.gserviceaccount.com
  - upload to jenkins configureation file:
    for pipeline gcloud access
      
  configure tools:
  - docker
  - nodejs
  - sonarqube
  
  step 4: 
    - create cicd pipeline for dev and prod env:
      using Jenkinsfile form github.
    - run the pipeline

step 