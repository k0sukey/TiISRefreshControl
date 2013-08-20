var TiISRefreshControl = require('be.k0suke.tiisrefreshcontrol');
Ti.API.info("module is => " + TiISRefreshControl);

var win = Ti.UI.createWindow();

/*
var tableView = Ti.UI.createTableView({
	data: [
		{ title: 'row0' },
		{ title: 'row1' },
		{ title: 'row2' },
		{ title: 'row3' },
		{ title: 'row4' },
		{ title: 'row5' },
		{ title: 'row6' },
		{ title: 'row7' },
		{ title: 'row8' },
		{ title: 'row9' }
	]
});
win.add(tableView);

tableView.addEventListener('refreshstart', function(){
	setTimeout(function(){
		tableView.refreshFinish();
		win.remove(tableView);
	}, 5000);
});
*/

var listView = Ti.UI.createListView();
var sections = [];

var fruitSection = Ti.UI.createListSection({ headerTitle: 'Fruits'});
var fruitDataSet = [
    {properties: { title: 'Apple'}},
    {properties: { title: 'Banana'}},
];
fruitSection.setItems(fruitDataSet);
sections.push(fruitSection);

var vegSection = Ti.UI.createListSection({ headerTitle: 'Vegetables'});
var vegDataSet = [
    {properties: { title: 'Carrots'}},
    {properties: { title: 'Potatoes'}},
];
vegSection.setItems(vegDataSet);
sections.push(vegSection);

listView.sections = sections;
win.add(listView);

var fishSection = Ti.UI.createListSection({ headerTitle: 'Fish'});
var fishDataSet = [
    {properties: { title: 'Cod'}},
    {properties: { title: 'Haddock'}},
];
fishSection.setItems(fishDataSet);
listView.appendSection(fishSection);

listView.addEventListener('refreshstart', function(){
	console.log('isRefreshing: ' + listView.isRefreshing());
	setTimeout(function(){
		listView.refreshFinish();

		setTimeout(function(){
			console.log('isRefreshing: ' + listView.isRefreshing());
		}, 5000);
	}, 5000);
});
console.log('isRefreshing: ' + listView.isRefreshing());

win.open();