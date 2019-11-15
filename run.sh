echo $1
echo $2

./teams/$1/startAll &
./teams/$2/startAll &
rcssserver server::synch_mode=true

D="$(date +%Y%m%d%H%M%S)"
mv *.rcg "$1_vs_$2-$D.rcg"
mv *.rcl "$1_vs_$2-$D.rcl"
mv *.rc? results/