fi=["1.txt", "2.txt", "3.txt", "4.txt"]
wordloader=require("./wordloader").wordloader
myl = new wordloader("C:\\Users\\Loyuki\\Documents\\words\\", fi)
myl.on("end", function(){
	console.log(myl.getwords());
})