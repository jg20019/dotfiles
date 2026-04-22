function ,check-run-properties
  ssh $argv "cat /usr/local/wildfly/standalone/configuration/run.properties"
end
