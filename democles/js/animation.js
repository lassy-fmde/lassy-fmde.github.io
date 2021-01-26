function log(message) {
	var e = $$('p')[0];
	e.innerHTML = e.innerHTML + message + "<br>";
}

function slideOnce(elements) {
	var qEnd =  {position:'end', scope: 'slideshow'};
	
	var duration = 3;
	var pixelsToMoveWhileFading = (360-156) / (duration + 1);
	var pixelsToMoveBetweenFades = pixelsToMoveWhileFading * duration;
	
	elements.each(function(e) {
		e.style['left'] = 0;
	});
	
	for (var index = 0; index < elements.length; ++index) {
  		var e1 = elements[index];
  		var e2 = elements[(index + 1) % elements.length];

		new Effect.Parallel(
			[ new Effect.Move(e1, {sync: true, queue: qEnd, duration: 1.0, delay: 0, x: -pixelsToMoveWhileFading, mode: 'relative', transition: Effect.Transitions.linear }),
			  new Effect.Move(e2, {sync: true, queue: qEnd, duration: 1.0, delay: 0, x: -pixelsToMoveWhileFading, mode: 'relative', transition: Effect.Transitions.linear }),  
			  new Effect.Opacity(e1, {sync: true, duration: 1.0, queue: qEnd, delay: 0, from: 1.0, to: 0.0, transition: Effect.Transitions.linear }), 
			  new Effect.Opacity(e2, {sync: true, duration: 1.0, queue: qEnd, delay: 0, from: 0.0, to: 1.0, transition: Effect.Transitions.linear })
			],
		  
			{ queue: qEnd, duration: 1.0, delay: 0.0, transition: Effect.Transitions.linear
			}
	  	);  
	  			
		new Effect.Parallel(
			[ new Effect.Move(e1, {sync: true, queue: qEnd, duration: duration, delay: 0, x: -pixelsToMoveBetweenFades, mode: 'relative', transition: Effect.Transitions.linear }),
			  new Effect.Move(e2, {sync: true, queue: qEnd, duration: duration, delay: 0, x: -pixelsToMoveBetweenFades, mode: 'relative', transition: Effect.Transitions.linear }) 
			],
		  
			{ queue: qEnd, duration: duration, delay: 0.0, transition: Effect.Transitions.linear
			}
	  	);

	}
	
	slideOnce.delay(duration * elements.length, elements);
}

function makeSlider(id) {

	$(id).setStyle({ backgroundImage: "url('')" });
	
	var elements = $(id).childElements();

	elements.each(function(e) {
		e.setOpacity(0.0);
		e.show();
	});
	
	elements[0].setOpacity(1.0);

	slideOnce(elements);	
}

