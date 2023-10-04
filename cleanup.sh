container_id=$1  # Receive the container ID from the command-line argument

echo "Monitoring events for container ID: $container_id"
docker events --filter "container=$container_id" --filter "event=die" | while read -r line
do
  echo "Container has exited. Revoking xhost permissions."
  xhost -local:$container_id
  exit 0
done

