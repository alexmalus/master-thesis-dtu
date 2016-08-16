$ ->
	$('#menu-toggle').click -> 
  	$('#wrapper').toggleClass('toggled')
  $('#release_hideshow').click -> 
  	$('#releases_content').toggle('show')
  	console.log("just some toggle around")
  $('#sprint_hideshow').click -> 
  	$('#sprints_content').toggle('show')