%finds onset time of a function by successive linear regressions
% compute linear regression using all possible intervals (stepped by 5 ms).
% keep track of the fit r^2, the slope m, and the length of the regressed
% vector.
% we want to maximize all three - the best fitting line with the steepest
% (positive) slope with the longest vector length.

% so we create a composite variable of these three and find the maximum.
% the onset time is the start point of that one regression that maximizes
% the composite.

function [onset_index] = regression_change_point_Heitz_test(SDF)
y = SDF;
x = 1:length(SDF); %actual x values do not need to be used; function returns index of onset time
%for debugging:
%x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601];
%y = [29.3789817574035,28.9421460316688,29.1933274787975,29.6918974113103,29.5379952701937,29.8196018309203,30.3484262147843,30.2159652818015,31.2207622781480,31.8600752592560,32.4101222537976,32.8798600151801,31.9684427305667,30.6456796285952,30.5089422581021,32.1576713543271,32.3611110600087,32.0633546267658,31.6277098027161,33.8458629960149,34.1648483533068,33.1946957041202,33.8388915879738,36.2878736156842,35.9340677876937,35.3443693604850,34.6880192245025,35.3376365221783,34.4150004379061,33.0109374763602,32.7721498113698,32.9883065242914,33.9695640225507,33.9197085493058,34.1155654404777,33.7343025668925,34.5778920697201,35.0892945029808,34.1343781088699,33.4143241942200,32.0957690695693,33.9339922032770,34.8241960728016,34.6769541452419,34.8817276888372,34.5171814870691,35.2820277391863,35.0853684612347,33.9143885367771,34.4494124831038,34.8885065679072,35.2554164788972,34.2471359861241,33.4667333046896,35.5254735997344,35.7186395213538,37.3568806549746,38.0642001014175,38.4197125769639,38.6731784467615,37.4729431295520,37.9058855953932,39.4892557209714,41.4385274512831,42.7872995828220,41.8475572188233,40.2021589595139,38.3281976507033,37.1634057728430,35.5652700567771,34.5730625213479,34.4998652180667,34.7280748578621,33.6640129493800,32.1976721244483,30.7092544516138,31.8939003307278,31.8858812925237,30.8605968554386,30.9009145152781,30.5883277802730,29.5018274630438,28.8458324986230,29.0339413176097,28.8433915954032,28.5065076680329,28.1384194825005,27.1179416392295,26.5399968811625,25.4876604612383,24.9771280895832,24.6631324910344,25.8098792555125,25.3733240024789,25.0577410288755,26.1134276968355,27.6642680440701,27.2907528460617,27.6348727548636,29.4752971513835,31.1875952193841,32.7951599432866,32.9051989143578,33.1679103175543,32.2379350483311,33.5795103712444,33.6219783520924,35.2111874227536,35.3175115020591,34.2332005044307,34.0942834113207,32.9417605555366,32.8152273944876,32.4068865311682,31.8845295075997,30.6939336936219,31.2923441820502,31.8272699466372,31.0099336200157,30.4084023412051,30.5972858787305,30.9389353369246,30.0668929501535,29.4907009415211,30.3512811413633,31.0159906382941,30.2022348562553,30.3211572999943,30.7526250578413,30.5359316996436,30.1503364316470,29.7139178500531,28.6402506031249,28.7017001555479,30.4142091642218,30.7078051860923,31.7803151708700,33.1375877549446,33.1866119366535,32.7986037966717,31.6432543800094,30.8701190373519,30.2496947418361,30.3797768088666,30.1018841347171,29.7486889248999,29.3611484589546,28.3012842333079,27.0317194413719,26.4321102253215,27.3945444373753,28.1605674068766,28.1705726942588,28.6407926507590,28.5624679274193,27.6308539768697,26.3667194498136,26.4641502977544,27.0107463280184,26.2973355321823,27.9129903980607,27.5726698758804,28.5852535958442,29.3302197502915,29.3156385480148,29.0418626455613,29.3636658541274,30.5662007398930,32.6706275432974,33.0153471305283,32.7370512134566,32.2670201485891,31.7090572840799,31.8848588986268,31.5861759701894,31.7800131333192,33.4916573865031,35.7127857188408,37.3004229261536,37.9283179070046,40.2695255493446,39.7341055420865,38.9703025804707,39.4678920810654,41.0886010552795,42.2669311182834,44.0196444504451,45.8289928055840,47.0056448318651,47.9334144547286,48.0299104670075,48.5724797908762,49.1936706573926,48.5081391793267,47.4025460171191,49.5775721868186,49.3444345755104,50.3765957026110,50.4830440243575,49.5716402011946,48.3376382580082,47.7153788103745,50.0482004042328,51.9112114033917,54.1997641664341,56.5905679335675,58.2986174166938,58.9994063340760,60.0295186108077,59.8097442616457,57.8277053431556,56.6682534216920,56.5120591179081,57.3221138344937,57.0564082006598,57.1863817887135,58.0576352178852,61.1812016852961,62.9749460044888,65.6018665466873,65.7496379157463,67.7338674458745,69.6001408240194,70.0021210484103,69.2570892112729,70.8397560796704,70.4543587499652,70.1187513932148,69.8035321146320,69.4855878534737,69.1446316944004,68.1668039451949,68.3670161913335,66.9071521833637,65.6404888535405,63.8177964963452,63.2073345296207,62.3075547369766,60.6804694376677,59.5750584331991,57.9134934717636,57.5711581662922,56.9198135466856,56.2262409896304,55.5532805736266,55.5748689554836,54.4611073140110,53.6652292056307,52.9877181430233,53.7827847606454,55.0223462973075,54.3510350963805,53.7381105715984,53.1445481190863,51.2562243583213,48.9704483470075,48.6121884006785,48.2473745508112,47.9114503893802,50.3011835782662,52.1107484333736,51.7682916777697,52.0130684893117,51.7401953212677,51.9709863462734,53.0616243017602,53.0312165213459,51.9622569418722,50.6009889658776,51.8714629257677,53.9971939515933,53.6211793803774,53.7775083331666,52.7987378181359,50.7863273412892,49.7424784817603,49.8589621202895,49.5921721914381,47.9193917529343,47.1838409495669,46.7767609975051,47.8187757822858,47.8925653870225,49.0543899921730,48.4888657816964,49.3926453527914,48.7568322921118,46.9681929969512,46.1725426760508,44.4321355324046,44.4773164451491,43.7164182524148,42.0322913082044,41.4279175101590,40.5747817247749,40.3059092454596,39.5541880313830,39.2870605284510,41.2882352335144,40.5556408395057,41.0474854959499,41.1528157522545,43.1924882419433,42.4776778143576,44.2403847932166,44.6675209757797,44.7418659627583,43.9764343840847,44.3089138037578,42.9767818541445,41.8059604708152,41.4186373594372,41.2585616586364,41.2513721381326,40.5821420203320,41.7596191358875,41.4491116000193,41.3594755958803,42.0320605532079,41.5643568271965,41.4314206709360,42.0414751541317,42.9126651511930,43.1631560857007,42.5259149433797,40.9206934654142,39.0899872869105,39.2286410843271,38.6789121028213,37.8784584220675,38.3799300399105,37.3378588399704,38.4677535052460,38.9452808221843,39.2295249656226,39.4267678197712,39.5302812870123,38.2929397962440,36.6416693963404,34.8269446885049,34.4280132213743,34.5578706165792,34.1269643566141,33.5562140313908,34.2770333104660,34.7190685702570,34.4269488455190,33.9055655017811,32.6443934246733,31.0989300846562,30.2083119180035,29.6419299238002,29.8082980106437,29.5927869219477,30.6092013815642,30.6112722251422,30.2697777473536,29.1779001512434,27.9030434087611,27.2282121132992,27.4613357536091,27.9502898705769,27.8883848279614,26.9192377717438,26.4241666624193,25.3504269596719,26.2166329500007,25.6806237324473,25.3221928068877,25.0868980165917,26.1742399174355,27.7268637616208,30.0641740377339,31.8695679314269,32.8006429586454,33.3848329008711,32.5150090906778,31.1624320654090,30.9867077908000,30.6531203763229,30.8580947264621,31.2758243830258,31.6857890322341,31.5249969157168,31.0476596275430,30.5727310150013,29.4200066211456,28.7708925146512,28.2641590001600,27.8930523642530,26.8656976040897,27.6593216396916,28.3675837397530,28.3517988767255,28.1150054262396,28.4199882178687,28.3014584345632,29.3520847928290,28.7263675255067,28.2814955534085,29.2241249350237,31.2592264855187,32.9271076185944,33.0930230774830,34.1127525946244,35.3970423480546,36.0486761524630,36.4105419422231,36.7239672029446,35.6513244165631,35.4586516222093,34.9639931713561,34.9591748396624,35.1838759332573,35.4642022443101,34.4078016112963,34.9594685579702,35.3947574739488,35.7638558889773,36.0992195372611,36.3737109823986,36.6328886383117,36.2250793342647,36.2745306431623,35.0892569218196,34.9100688104183,35.0841381084286,34.6902745110501,33.4661769941473,33.3440571911143,33.5731203112484,33.9186455045785,33.5993000216850,33.7682714793803,34.0485963049953,33.0634063184050,32.3477239256536,32.4371257810347,33.4580346497865,32.7176099011716,32.7480383742029,33.0409225224727,32.7582125058334,32.9787242522248,32.6602442250098,32.1987773816224,32.3121809969573,33.3655174844058,33.3119978734220,32.2253825187787,32.1366744143734,33.7429599609734,33.1503180199430,32.5440144325696,31.2918873457958,31.2040115162469,30.8723000424552,30.4562880251597,29.3132157011914,28.6707001793847,30.2083781951165,29.7371437597134,29.2853181989772,29.5469609614133,28.6846204392806,27.4754779495324,27.5550904560092,28.0348373094886,28.6393930951226,30.6126829133106,30.9789956816712,30.0602595124496,29.4560551613983,28.9883846363035,29.9205191588660,29.9231951972792,30.9890829697276,31.6560764436436,32.9144880670076,32.2703536696899,31.6543311545793,30.3881648206176,29.6452354953478,29.1322153110013,29.3325059475737,29.7775383928860,29.6362565434222,29.2974611767707,29.5768381746111,28.7457845396203,28.8651420416200,29.3302363562522,28.5229847222595,29.3441578717636,29.3349966136518,29.0887420249789,28.0260283277553,27.4383911035040,27.0206978678213,25.9996388154080,26.1564638244259,26.7004004114579,27.3754556002429,27.3732458284515,28.5378558893911,30.0012820449445,30.1850748352626,29.2834152332140,28.0617056903323,29.4190686415713,30.2591922646816,30.9005066682979,30.8016385601369,31.1063664704537,30.8694266229369,29.8255259321563,30.5324838130843,31.1139811515611,30.9494231604500,31.2802612534911,33.0523816226108,33.2421980036557,32.2456207227268,32.8789250923710,32.0414893105303,31.4073887849682,30.1683931194893,30.1010022523953,30.4715774635769,29.6356887131744,30.3984010683246,29.6241679697382,29.8009042500079,28.8954241904049,29.0310992911346,28.7900294766463,29.8107070870121,30.5390210641452,31.1664305089197,32.3872072877296,35.0614608529471,34.8673596511116,35.0241676007943,35.9533097616810,36.4827406091212,36.1755050662429,35.5604975075219,34.8761909477995,34.1905119481554,32.8139265073086,31.3231684945327,30.5138747364337,31.2771031326877,30.5268736922169,29.9308103375599,32.1503348095338,33.1645243578980,35.1248510471070,35.9652829828342,35.1252752627914,33.7125471461060,34.8730079336315,34.8073535628467,35.0156458055558,35.2890180079245,36.2553898739792,36.0949532599291,35.5576955244227,34.2193550717201,32.7026241375702,33.1414699722538,32.8846533651271,31.7702457083971,32.3530681024021,32.1955034480626,31.1096517459574,31.7882644364085,31.6600151978477,32.6204321167822,33.9322908156197,34.6005293398149,33.7006352736776,33.6536409036962,33.2383695878945,32.6678390851138,32.7505443605322,33.0870813925647,33.5032961455093,33.9260120431065,33.5862914001383,32.3966834412495,30.9482365351553,32.1717673872369,31.5268897010676,31.6532044119464,31.3717239747381,30.2249051566748,29.5395587764303,29.0422310250415,29.2701033404048,29.0267866730470];
% 



startP = 0;
endP = length(x);
iter = 0;

while startP < length(x)-5
    endP = length(x); %re-set stopping point to end of array and start again
    startP = startP + 5;
    startP
    while endP > startP + 5
        iter = iter + 1;
        curr_segment_x = x(startP:endP);
        curr_segment_y = y(startP:endP);
        
        [m b R] = linear_regression(curr_segment_y,curr_segment_x);
        
        
        results.time(iter,1) = startP;%-(b / m); %solve for x-intercept (onset time)
        results.m(iter,1) = m;
        results.b(iter,1) = b;
        results.R(iter,1) = R;
        results.length(iter,1) = length(startP:endP);
        
        endP = endP-5;
    end
end




%we want to use only regressions with positive slopes, so set all others to
%NaN

results.time(find(results.m <= 0)) = NaN;
results.m(find(results.m <= 0)) = NaN;
results.b(find(results.m <= 0)) = NaN;
results.R(find(results.m <= 0)) = NaN;
results.length(find(results.length <= 0)) = NaN;


%now remove any segments > 50 ms wide because those aren't sharp enough
% results.time(find(results.length > 50)) = NaN;
% results.m(find(results.length > 50)) = NaN;
% results.b(find(results.length > 50)) = NaN;
% results.r(find(results.length > 50)) = NaN;
% results.length(find(results.length > 50)) = NaN;

%create composite variable
composite = results.m .* results.R .* results.length;

[mval mdex] = max(composite);
onset_index = results.time(mdex);