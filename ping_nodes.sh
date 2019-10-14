# Iterates over lines of specified text file of servers, sends ping to evaluate if online.
# Outputs CSV : NodeName | Online?

# Argument 1: file name to be processed
# Argument 2: file name to write to (csv)

# Quickstart command - ./find_online.sh unhealthy_nodes_list.txt test_script.csv

serverList=$1
outFile=$2

# Clear output file if already exists
>$outFile

# Set max number of concurrent processes
N=32

# Ping each node to see if active. Output status in csv format
while read node; do
	# If i is zero, call wait. uncrement i after zero test.
	((i=i%N)); ((i++==0)) && wait
	ping -c2 -W2 $node && echo "${node},active" >> $outFile || echo "${node},inactive" >>$outFile &
done <$serverList
echo Done