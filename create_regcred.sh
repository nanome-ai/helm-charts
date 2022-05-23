kubectl delete secret regcred
kubectl create secret docker-registry regcred  \
--docker-server=441665557124.dkr.ecr.us-west-1.amazonaws.com \
--docker-username=AWS \
--docker-password=$(aws ecr get-login-password)