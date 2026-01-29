

# Printer: http://10.10.10.40/general/status.html
# Printer: http://10.10.10.66 IIS
# RE220 MAC Address: 5C:62:8B:A6:88:48
for x in  147 ; do
  echo "==== http://10.10.10.$x"
  { curl -v "http://10.10.10.$x" && exit; } || :
  echo
done
