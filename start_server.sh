echo "start application server"
unzip reqres_products
nohup java -Dreqres_products-app -jar /home/ubuntu/reqres_products/reqres_products-0.0.1-SNAPSHOT.jar > /home/ubuntu/reqres_products/nohup.out 2>&1 &
