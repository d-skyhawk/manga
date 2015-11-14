echo "Enter Manga name:"
read manga
echo "Enter the chapter number:"
read chap
mkdir $manga
cd $manga
for i in {19..25}
do
	echo "Downloading $i page....."
	wget -o log.txt -O $i.html -c www.mangareader.net/$manga/$chap/$i
	grep '<div id=\"imgholder\"><a href=' $i.html > jump.txt
	link=$(head -n 1 jump.txt)
	starti="$(echo $link | grep -aob '"' | grep -oE '[0-9]+' | sed "11q;d")"
	endi="$(echo $link | grep -aob '"' | grep -oE '[0-9]+' | sed "12q;d")"
	length=$((endi-starti))
	image=${link:$((starti+1)):$((length-1))}
	length=${#image}
	if [[ "$length" -eq 0 ]]; then
		break
	fi
	wget -O $i.jpg -o log.txt -c $image
done
echo "Converting to pdf..."
convert *.jpg chap.pdf
echo "Cleaning up....."
rm *.html
rm jump.txt
rm log.txt