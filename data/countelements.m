data = readtable('Data.csv');
WeaponsUsed = data.(17);
WeaponsUsedID = data.(16);
Area = data.(6);
AreaID = data.(5);
B = cellstr(num2str(WeaponsUsedID));
%mat = zeros(9999,1);
%for f = 1:9999
%    mat(f) = WeaponsUsed(f);
%end
B = categorical(B);
A = countcats(B);
figure;
scatter(AreaID,WeaponsUsedID);
ylabel('Weapons Used ID');
xlabel('Area ID');