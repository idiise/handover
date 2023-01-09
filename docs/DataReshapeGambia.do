****************************************************
************* Manual Edits *************************
* Name of the file in input
global filei1 "october2022"					// Put file name here

******************************************************


* Settings
global ADM0_NAME "Gambia (The)" // 

global outfol "C:\Users\USER MSI\Documents\WFP\Upload Market Price\Gambia\\"		// Change this to run on your folder
global fileo1 "${fileo1}"
global fileo1 "PriceUploadReport"  

cap log close
global fileo1 "${dtype}_${fileo1}"
global data "${outfol}\\${filei1}"
global output "${outfol}\\${fileo1}.dta"
local c_date= c(current_date)
global date_string = subinstr(strtrim("`c_date'"), " " , "_", .)

****************************************************
cd "${outfol}"

cap log close 

log using  "${outfol}\LOG_RawDataTransform - new.log", text replace
cap noi {
****************************************************

* import file
import excel  using "${data}",  clear  allstring 

	// Extract information on the date
	global date=A in 1
	gen datestring="${date}"
	gen datestring1=subinstr(datestring, " 00:00:00", "",.)
	gen date=daily(datestring1, "DMY", 2000)
	format date %td
	gen day=15
	gen month=month(date)
	gen year=year(date)
	drop date
	gen date = mdy(month, day, year)
	format date %td
	
	global month = month in 1
	
	/*
	gen datestringm=.
	replace datestringm=1 	if strpos(datestring1,"Jan")>0
	replace datestringm=2	if strpos(datestring1,"Feb")>0
	replace datestringm=3	if strpos(datestring1,"Mar")>0
	replace datestringm=4	if strpos(datestring1,"Apr")>0
	replace datestringm=5	if strpos(datestring1,"May")>0
	replace datestringm=6	if strpos(datestring1,"Jun")>0
	replace datestringm=7	if strpos(datestring1,"Jul")>0
	replace datestringm=8	if strpos(datestring1,"Aug")>0
	replace datestringm=9	if strpos(datestring1,"Sep")>0
	replace datestringm=10	if strpos(datestring1,"Oct")>0
	replace datestringm=11	if strpos(datestring1,"Nov")>0
	replace datestringm=12	if strpos(datestring1,"Dec")>0
	
	gen datestringd=15
	
	replace datestring2="20"+datestring2
	destring datestring2, gen(datestringy)
	gen date=mdy(datestringm,datestringd,datestringy)
	format date %td
	*/
	drop datestring* A day month year
	
	// Extract information on the Market
	
	local m "E H K N Q T W Z AC AF AI AL AO AR AU AX BA BD BG BJ BM BP BS BV BY CB CE CH"
	local n : word count `m'
	
	local c "E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ"
	local d: word count `c'


	forvalues i = 1/`n' {
	local a : word `i' of `m'
	global mktname_unclean=`a' in 4
	global mktname_unclean1=subinstr(strtrim("${mktname_unclean}"), " " , "", .)
	global mktname=subinstr(strtrim("${mktname_unclean1}"), "/" , "", .)
	display "${mktname}"
	
	local step=3*`i'
	local count1 = `step'-2
	local count2 = `step'-1
	local count3 = `step'
	
	local var1 : word `count1' of  `c'
	local var2 : word `count2' of  `c'
	local var3 : word `count3' of  `c'
	
		
	global  varname1_unclean=`var1' in 5
	global	varname1=subinstr(strtrim("${varname1_unclean}"), " " , "", .) 
	display "${varname1}_${mktname}"
	rename `var1'   ${varname1}_${mktname}

	global  varname2_unclean=`var2' in 5
	global	varname2=subinstr(strtrim("${varname2_unclean}"), " " , "", .) 
	display "${varname2}_${mktname}"
	rename `var2'   ${varname2}_${mktname}
	
	global  varname3_unclean=`var3' in 5
	global	varname3=subinstr(strtrim("${varname3_unclean}"), " " , "", .) 
	display "${varname3}_${mktname}"
	rename `var3'   ${varname3}_${mktname}


	}

	

	drop in 1
		drop in 1
			drop in 1
				drop in 1
					drop in 1
					
rename (B C D) (commodity item standardquantity)

	// keep only relevant information
	drop if commodity==""
	
	replace commodity=subinstr(strtrim(commodity), "/" , "", .)

	// Rename Commodities
	gen CommodityName=""
	replace CommodityName="Apples (red)" 	if commodity=="Apple"
	replace CommodityName="Bananas" 		if commodity=="Banana"
	replace CommodityName="Beans (dry)"		if commodity=="Dry Beans"
	replace CommodityName="Bread" 			if commodity=="Bread"
	replace CommodityName="Butter" 			if commodity=="Butter (250Gram)"
	replace CommodityName="Cabbage"			if commodity=="Cabbage"
	replace CommodityName="Carrots"			if commodity=="Carrot"
	replace CommodityName="Cassava" 		if commodity=="Cassava"
	replace CommodityName="Cassava leaves"	if commodity=="Cassava Leaves"
	replace CommodityName="Cassava meal (gari)" if commodity=="Gari (Cassava Flour)"
	replace CommodityName="Cocoa (powder)" 	if commodity=="Powdered Tea (Ovaltine, 200gr)"
	replace CommodityName="Coffee (instant)" if commodity=="Coffee-Nescafe (50gr)"
	replace CommodityName="Cucumbers" 		if commodity=="Cucumber"
	replace CommodityName="Dates" 			if commodity=="Dates"
	replace CommodityName="Eggs"			if commodity=="Eggs"
	replace CommodityName="Eggplants"		if commodity=="Garden Eggs"
	replace CommodityName="Fish (bonga)" 	if commodity=="Fresh Bonga"
	replace CommodityName="Fish (catfish)" 	if commodity=="Cat Fish"
	replace CommodityName="Fish (dry)"		if commodity=="Dried fish"
	replace CommodityName="Fish (sardine, canned)" if commodity=="Sardine (Tin Fish 125g)"
	replace CommodityName="Fish (smoked)" 	if commodity=="Smoked Bonga"
	replace CommodityName="Fish (tilapia)" 	if commodity=="Tilapia"
	replace CommodityName="Fonio" 			if commodity=="Fonio"
	replace CommodityName="Fuel (diesel)"	if commodity=="Diesel"
	replace CommodityName="Fuel (petrol-gasoline)" if commodity=="Petrol"
	replace CommodityName="Garlic"			if commodity=="Garlic"
	replace CommodityName="Groundnuts (paste)" if commodity=="Peanut Butter"
	replace CommodityName="Groundnuts (paste)" if commodity=="Peanut Buter"
	replace CommodityName="Groundnuts (shelled)" if commodity=="Groundnuts-Shelled"
	replace CommodityName="Honey"			if commodity=="Honey"
	replace CommodityName="Lemons" 			if commodity=="Lime"
	replace CommodityName="Lettuce" 		if commodity=="Lettuce (Salad)"
	replace CommodityName="Maize" 			if commodity=="Maize"
	replace CommodityName="Mangoes"			if commodity=="Mangoes"
	replace CommodityName="Meat (beef)" 	if commodity=="Beef"
	replace CommodityName="Meat (beef, canned)" if commodity=="Canned meat (200 Gram)"
	replace CommodityName="Meat (chicken)" 	if commodity=="Chicken (Local)"
	replace CommodityName="Meat (goat)" 	if commodity=="Goat Meat"
	replace CommodityName="Meat (pork)" 	if commodity=="Pork"
	replace CommodityName="Meat (sheep)" 	if commodity=="Sheep meat (mutton)"
	replace CommodityName="Milk" 			if commodity=="Fresh Milk"
	replace CommodityName="Milk (powder)" 	if commodity=="Powdered Milk(400g)"
	replace CommodityName="Millet" 			if commodity=="Millet"
	replace CommodityName="Oil (palm)" 		if commodity=="Palm Oil"
	replace CommodityName="Oil (vegetable)" if commodity=="Vegetable Oil (Sold loose)"
	replace CommodityName="Okra (fresh)" 	if commodity=="Okra"
	replace CommodityName="Onions" 			if commodity=="Onion"
	replace CommodityName="Oranges (big size)" if commodity=="Oranges"
	replace CommodityName="Pasta (spaghetti)" if commodity=="Spaghetti"
	replace CommodityName="Peppers (dried)" if commodity=="Small Dry Pepper"
	replace CommodityName="Peppers (fresh)" if commodity=="Small Pepper-Fresh"
	replace CommodityName="Peppers (red)" 	if commodity=="Big Red Pepper"
	replace CommodityName="Potatoes (Irish)" if commodity=="Potatoes (Irish)"
	replace CommodityName="Pumpkin" 		if commodity=="Pumpkin"
	replace CommodityName="Rice (basmati, broken)" if commodity=="Basmati Rice (Imported)"
	replace CommodityName="Rice (long grain, imported)" if commodity=="Long-Grained Rice (Imported)"
	replace CommodityName="Rice (medium grain, imported)" if commodity=="Medium-Grained Rice (Imported)"
	replace CommodityName="Rice (paddy, long grain, local)" if commodity=="Paddy Rice Long Grain (Local)"
	replace CommodityName="Rice (small grain, imported)" if commodity=="Small grained rice (imported)"
	replace CommodityName="Salt" 			if commodity=="Salt"
	replace CommodityName="Shrimps" 		if commodity=="Shrimps"
	replace CommodityName="Sugar" 			if commodity=="Sugar"
	replace CommodityName="Sweet potatoes" 	if commodity=="Sweet Potatoes"
	replace CommodityName="Tea" 			if commodity=="Tea Bags(200g)"
	replace CommodityName="Tea (green)" 	if commodity=="Chinese Green Tea (25g) (Ataya)"
	replace CommodityName="Tomatoes"		if commodity=="Tomatoes-Fresh"
	replace CommodityName="Tomatoes (paste)" if commodity=="Tomato Puree (Paste,70g)"
	replace CommodityName="Watermelons" 	if commodity=="Water Melon"
	replace CommodityName="Yogurt" 			if commodity=="Yoghurt(125g)"
	
	drop if CommodityName==""
	drop commodity
	
	reshape long Adjustedprice_ Price_ Quantity_, i(CommodityName item standardquantity date) j(market) string
	rename (Adjustedprice_ Price_ Quantity_ CommodityName item standardquantity market date) (Adjustedprice Price Quantity CommodityName Item StandardQuantity Market Date)

	// Calcualte price in standard DataBase Unit
	destring Price, replace
	destring Adjustedprice, replace
	destring Quantity, replace
	destring StandardQuantity, replace
	gen StandardPrice = Price/Quantity*1000 if Quantity!=1
	replace StandardPrice = Price if Quantity==1
	
	gen StandardAdjustedPrice =  Adjustedprice/StandardQuantity*1000 if Quantity!=1
	replace StandardAdjustedPrice = Adjustedprice if Quantity==1
	
	gen check=0
	
	replace check=1 if StandardAdjustedPrice != StandardPrice
	
	gen Comment= ""
	replace Comment = "Please check the price in the original file and insert the correct price" if check==1
	
	rename StandardPrice AdjustedPrice // this is to avoid re-doing the mapping schema in databridges - keeping the headers consistent
	
	drop  StandardQuantity
	gen   StandardQuantity=""
	
	replace StandardQuantity="125 G" if CommodityName == "Fish (sardine, canned)" | CommodityName == "Yogurt"
	replace StandardQuantity="200 G" if CommodityName == "Cocoa (powder)"
	replace StandardQuantity="70 G" if CommodityName == "Tomatoes (paste)"
	replace StandardQuantity="L" 	if CommodityName == "Fuel (diesel)" | CommodityName == "Fuel (petrol-gasoline)" | CommodityName == "Oil (palm)" | CommodityName == "Oil (vegetable)"

	replace StandardQuantity="KG" 	if CommodityName == "Apples (red)"
	replace StandardQuantity="KG" 	if CommodityName == "Bananas"
	replace StandardQuantity="KG" 	if CommodityName == "Beans (dry)"
	replace StandardQuantity="KG" 	if CommodityName == "Bread"
	replace StandardQuantity="KG" 	if CommodityName == "Butter"
	replace StandardQuantity="KG" 	if CommodityName == "Cabbage"
	replace StandardQuantity="KG" 	if CommodityName == "Carrots"
	replace StandardQuantity="KG" 	if CommodityName == "Cassava"
	replace StandardQuantity="KG" 	if CommodityName == "Cassava leaves"
	replace StandardQuantity="KG" 	if CommodityName == "Cassava meal (gari)"
	replace StandardQuantity="KG" 	if CommodityName == "Cucumbers"
	replace StandardQuantity="KG" 	if CommodityName == "Dates"
	replace StandardQuantity="KG" 	if CommodityName == "Eggplants"
	replace StandardQuantity="KG" 	if CommodityName == "Fish (bonga)"
	replace StandardQuantity="KG" 	if CommodityName == "Fish (catfish)"
	replace StandardQuantity="KG" 	if CommodityName == "Fish (dry)"
	replace StandardQuantity="KG" 	if CommodityName == "Fish (smoked)"
	replace StandardQuantity="KG" 	if CommodityName == "Fish (tilapia)"
	replace StandardQuantity="KG" 	if CommodityName == "Garlic"
	replace StandardQuantity="KG" 	if CommodityName == "Groundnuts (paste)"
	replace StandardQuantity="KG" 	if CommodityName == "Groundnuts (shelled)"
	replace StandardQuantity="KG" 	if CommodityName == "Honey"
	replace StandardQuantity="KG" 	if CommodityName == "Lemons"
	replace StandardQuantity="KG" 	if CommodityName == "Lettuce"
	replace StandardQuantity="KG" 	if CommodityName == "Maize"
	replace StandardQuantity="KG" 	if CommodityName == "Mangoes"
	replace StandardQuantity="KG" 	if CommodityName == "Meat (beef)"
	replace StandardQuantity="KG" 	if CommodityName == "Meat (chicken)"
	replace StandardQuantity="KG" 	if CommodityName == "Meat (goat)"
	replace StandardQuantity="KG" 	if CommodityName == "Meat (pork)"
	replace StandardQuantity="KG" 	if CommodityName == "Meat (sheep)"
	replace StandardQuantity="KG" 	if CommodityName == "Milk"
	replace StandardQuantity="KG" 	if CommodityName == "Millet"
	replace StandardQuantity="KG" 	if CommodityName == "Okra (fresh)"
	replace StandardQuantity="KG" 	if CommodityName == "Onions"
	replace StandardQuantity="KG" 	if CommodityName == "Oranges (big size)"
	replace StandardQuantity="KG" 	if CommodityName == "Peppers (fresh)"
	replace StandardQuantity="KG" 	if CommodityName == "Peppers (red)"
	replace StandardQuantity="KG" 	if CommodityName == "Potatoes (Irish)"
	replace StandardQuantity="KG" 	if CommodityName == "Pumpkin"
	replace StandardQuantity="KG" 	if CommodityName == "Rice (basmati, broken)"
	replace StandardQuantity="KG" 	if CommodityName == "Rice (long grain, imported)"
	replace StandardQuantity="KG" 	if CommodityName == "Rice (medium grain, imported)"
	replace StandardQuantity="KG" 	if CommodityName == "Rice (paddy, long grain, local)"
	replace StandardQuantity="KG" 	if CommodityName == "Rice (small grain, imported)"
	replace StandardQuantity="KG" 	if CommodityName == "Salt"
	replace StandardQuantity="KG" 	if CommodityName == "Shrimps"
	replace StandardQuantity="KG" 	if CommodityName == "Sugar"
	replace StandardQuantity="KG" 	if CommodityName == "Sweet potatoes"
	replace StandardQuantity="KG" 	if CommodityName == "Tomatoes"
	replace StandardQuantity="KG" 	if CommodityName == "Watermelons"


	replace StandardQuantity="Unit" if CommodityName == "Coffee (instant)"
	replace StandardQuantity="Unit" if CommodityName == "Eggs"
	replace StandardQuantity="Unit" if CommodityName == "Meat (beef, canned)"
	replace StandardQuantity="Unit" if CommodityName == "Milk (powder)"
	replace StandardQuantity="Unit" if CommodityName == "Pasta (spaghetti)"
	replace StandardQuantity="Unit" if CommodityName == "Tea"
	replace StandardQuantity="Unit" if CommodityName == "Tea (green)"
	replace StandardQuantity="Unit" if CommodityName == "Grand Total"
	
	
	replace Market = "Bakau"		if Market =="Bakau"
	replace Market = "Banjul"		if Market =="Banjul"
	replace Market = "Bansang"		if Market =="Bansang"
	replace Market = "Basse Santa su"	if Market =="BasseSantosu"
	replace Market = "Brikama"		if Market =="Brikama"
	replace Market = "Brikamaba"	if Market =="BrikamaBa"
	replace Market = "Essau / Barra" if Market =="EssauBarra"
	replace Market = "Farafenni"	if Market =="Farafenni"
	replace Market = "Fass Njaga Choi"	if Market =="FassNjagaChoi"
	replace Market = "Fatoto"		if Market =="Fatoto"
	replace Market = "Gunjur"		if Market =="Gunjur"
	replace Market = "Jarreng"		if Market =="Jareng"
	replace Market = "Kalagi"		if Market =="Kalagi"
	replace Market = "Kaur Wharf Town"	if Market =="KaurWharfTown"
	replace Market = "Ker Pate Kore" if Market =="KerrPatehKoreh"
	replace Market = "Kerewan"		if Market =="Kerewan"
	replace Market = "Kuntaur"		if Market =="Kuntaur"
	replace Market = "Kwinella Nya Kunda"	if Market =="KwinellaNyaKunda"
	replace Market = "Lamin"		if Market =="Lamin"
	replace Market = "Latri kunda"	if Market =="Latrikunda"
	replace Market = "Ndugu Kebbeh"	if Market =="NdunguKebbeh"
	replace Market = "Sare Bojo"	if Market =="SareBojo"
	replace Market = "Sare Ngai"	if Market =="SareNgai"
	replace Market = "Serrekunda"	if Market =="Serrekunda"
	replace Market = "Sibanor"		if Market =="Sibanor"
	replace Market = "Soma"			if Market =="Soma"
	replace Market = "Wassu"		if Market =="Wassu"
	replace Market = "Wellingara"	if Market =="Wellingaraba"


	keep CommodityName	Item	StandardQuantity	Date	Market	AdjustedPrice Comment
	order CommodityName	Item	StandardQuantity	Date	Market	AdjustedPrice Comment


	
	export excel using "${outfol}\\Reports\Report_${fileo1}_${date_string}_${month}.xlsx",  first(varl)  sheet("Data") sheetrep nolabel


}
if _rc {

preserve
clear all
set obs 1
gen MESSAGE="There was an error with the upload"
export excel using "${outfol}\Reports\Report_${filei}_${date_string}.xlsx",  first(varl) sh("ERROR")  sheetrep nolabel
cap copy "${outfol}\\Reports\Report_${filei}_${date_string}.xlsx" "${outfol}\\Reports\\PriceUploadReport.xlsx", replace
restore
log close
exit, clear STATA

}

else {
log close
exit, clear STATA
}
