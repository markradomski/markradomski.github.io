
int base_font_size = 16;
String global_app_status = "LOADING";
String data_points_status = "LOADING";
int bubble_overlap_allowed = 2;
int min_circle_size_to_display_text = 7;
int bubble_action_count = 0;
var shuffle_duration;
int internal_stage_size;

void setup()
{background( 255 );
size( 10, 10 );
dbg("PDE setup!");
}void setStageSize( int x, int y )
{size( x, y );
internal_stage_size = x + 50;
}void draw()
{background( 255, 255, 255 );
if ( device_type == "is_desktop" || ( device_type != "is_desktop" && data_points_status == "STEADY") )
{if ( active_data_point )
{drawDividingLines();
if ( scale_obj != undefined ) scale_obj.draw();
}drawDataPoints();
if ( data_points_status != "STEADY" )
{shuffleDataPoints();
}if ( !active_data_point )
{drawDividingLines();
if ( scale_obj != undefined ) scale_obj.draw();
}}else
{shuffleDataPoints();
context.fillStyle = "black";
context.textAlign = 'center';
context.font = "32px " + font_name + ", 'Dosis'";
context.fillText( processing_notification_text, stage_size[0] / 2, 100 );
}
}function drawCanvasCircle( x, y, radius, stroke, line_width, bubble_colour )
{context.fillStyle = bubble_colour;
context.beginPath();
context.arc( x, y, max( 0, radius ), 0, Math.PI*2, true );
context.closePath();
if( stroke )
{context.strokeStyle = stroke;
context.lineWidth = line_width;
context.stroke();
}context.fill();
}void drawScaleLabels()
{for ( var i = 0; i < scaleLabels_arr.length; i++ )
{scaleLabels_arr[i].draw();
}}void drawDividingLines()
{for ( var i = 0; i < dividinglines_arr.length; i++ )
{dividinglines_arr[i].draw();
}}void drawDataPoints()
{if ( data_points_status != "LOADING" )
{strokeWeight( 1 );
for ( int i = 0; i < datapoints_arr.length; i=i+1 )
{datapoints_arr[i].draw();
}}}
class DataPoint
{String _name;
String _alternativename;
float _primaryvalue;
String[] _subcategories_arr;
String[] _categories_arr;
String[] _types_arr;
String _onetowatch;
float _metric_001;
float _metric_002;
float _metric_003;
float _metric_004;
float normalised_metric_001;
float normalised_metric_002;
float normalised_metric_003;
float normalised_metric_004;
String _notes;
String _exclude;
String _bubble_link;
int _id;
int x;
int y;
int base_x;
int base_y;
float vX;
float vY;
float inactive_radius = 5;
float default_radius = 60;
float active_radius = inactive_radius;
int shuffling_radius;
int selected_radius;
int strokewidth = 10;
float current_radius = 10;
float target_radius = current_radius;
boolean active = true;
String status = "OFF";
var name_arr = [];
var alternative_name_arr = [];
var notes_arr = [];
String subcategories_str;
float subcategories_str_width;
var text_base_width = 0;
var text_colour = "black";
var source_link_position = [];
var bubble_colour;
var type_colour = "#DDD";
var stroke;
var stroke_width = 10;
var get_my_text_colour = false;
DataPoint( String _name, String _alternativename, float _primaryvalue, String[] _subcategories_arr, String[] _categories_arr, String[] _types_arr, String _onetowatch, float _metric_001, float _metric_002, float _metric_003, float _metric_004, String _notes, String _exclude, String _bubble_link, int _id )
{this._name = _name;
this._alternativename = _alternativename;
this._primaryvalue = _primaryvalue;
this._subcategories_arr = _subcategories_arr;
this._categories_arr = _categories_arr;
this._types_arr = _types_arr;
this._onetowatch = _onetowatch;
this._metric_001 = _metric_001;
this._metric_002 = _metric_002;
this._metric_003 = _metric_003;
this._metric_004 = _metric_004;
this._notes = _notes;
this._exclude = _exclude;
this._bubble_link = _bubble_link;
this._id = _id;
}void getInitialPosition()
{x = 100 + (( stage_size[0] - 100 ) / datapoints_arr.length ) * _id;
y = (25-random( 50 )) + ( stage_size[1] - vertical_buffer_amount ) - (((_primaryvalue - scale_obj._minimum ) / ( scale_obj._maximum - scale_obj._minimum )) * ( stage_size[1] - ( vertical_buffer_amount * 2 )));

//  RADIUS

		//  set start radius
		current_radius = 1;

		//  COLOUR

		//  set default colour
		resetBubble();

		if ( user_defined_palette )
		{
			for ( var j = 0; j < user_defined_palette.length; j ++ )
			{
				if ( user_defined_palette[j].id == _types_arr[0] )
				{
					type_colour = "#" + user_defined_palette[j].bubble_colour;

					return;
				}
			}
		}

		//  no user-defined colours - just use the set palette

		//  if this bubble has a type then get the relevant colour
		for ( var i = 0; i < filter_types_arr.length; i ++ )
		{
			if ( filter_types_arr[i].id == _types_arr[0] ) type_colour = "#" + filter_types_arr[i].bubble_colour;
		}

}void setupText()
{text_base_height = base_font_size;
name_arr = splitString( 10, 6, trimTrailingSpaces( _name ));
if ( _alternativename != "" ) alternative_name_arr = splitString( 35, 30, trimTrailingSpaces( _alternativename ));

context.font = "9px " + font_name + ", 'Dosis'";
for ( var i = 0; i < name_arr.length; i ++ ) text_base_width = max( context.measureText( name_arr[i] ).width, text_base_width );
_subcategories_arr = splitString( 20, 15, trimTrailingSpaces( _subcategories_arr.join(", ")) );
notes_arr = splitString( 30, 25, trimTrailingSpaces( _notes ));
}void splitString( int max_name_length, int insert_line_break_after, String string_to_split )
{var insert_line_break_at;
var return_arr = [string_to_split];
if ( string_to_split.length > max_name_length )
{var split_name_arr = string_to_split.split("");
insert_line_break_at = split_name_arr.indexOf( " ", insert_line_break_after );
if ( insert_line_break_at == -1 ) insert_line_break_at = split_name_arr.indexOf( "-", insert_line_break_after );
if ( insert_line_break_at != -1 )
{var sub_name = split_name_arr.splice( 0, insert_line_break_at );
return_arr = [ sub_name.join("")].concat( splitString( max_name_length, insert_line_break_after, trimTrailingSpaces( split_name_arr.join("") )));
}}return return_arr;
}
void draw()
{current_radius = Math.ceil( current_radius);
drawCanvasCircle( x, y, current_radius, stroke, stroke_width, bubble_colour );
if ( get_my_text_colour ) getMyTextColour();
var total_height = 0;
var show_subcategories_threshold = 23;
context.fillStyle = text_colour;
context.textAlign = 'center';
context.textBaseline = "bottom";
var name_font_size = 0;
if ( status != "NOTES" )
{if ( current_radius > min_circle_size_to_display_text )
{name_font_size = ( current_radius - minimum_radius + 5 ) / ( maximum_radius - minimum_radius );
name_font_size = 9 + ( name_font_size * 15 );
var text_new_width = text_base_width * ( name_font_size / 9 );
name_font_size = (( current_radius * 1.5 ) / text_base_width) * 9;
name_font_size = Math.min( name_font_size, 32);
name_font_size = Math.max( name_font_size, 9);
name_font_size = parseInt( name_font_size);
}var alternativename_font_size = 14;
var subcategories_font_size = Math.min( 16, name_font_size * 0.5 );
var total_text_height = 0;
total_text_height += ( name_arr.length * name_font_size );
if ( current_radius >= selected_radius) total_text_height += ( alternative_name_arr.length * alternativename_font_size );
if ( name_font_size > show_subcategories_threshold && current_radius > 60) total_text_height += ( _subcategories_arr.length * subcategories_font_size );
total_text_height /= 2;
var text_y_position = y - total_text_height + name_font_size;
context.font = name_font_size + "px " + font_name + ", 'Dosis'";
for ( var i = 0; i < name_arr.length; i++ )
{context.fillText( name_arr[i], x, text_y_position );
text_y_position += name_font_size;
}if ( current_radius >= selected_radius && data_points_status != "SHUFFLE" )
{if ( alternative_name_arr.length > 0 ) text_y_position += 5;
context.font = alternativename_font_size + "px " + font_name + ", 'Dosis'";
for ( var i = 0; i < alternative_name_arr.length; i++ )
{context.fillText( alternative_name_arr[i], x, text_y_position - alternativename_font_size );
text_y_position += alternativename_font_size;
}if ( alternative_name_arr.length > 0 ) text_y_position += 5
}if ( name_font_size > show_subcategories_threshold && current_radius > 60 )
{if ( alternative_name_arr.length > 0 ) text_y_position += 5;
context.font = subcategories_font_size + "px " + font_name + ", 'Dosis'";
for ( var i = 0; i < _subcategories_arr.length; i++ )
{context.fillText( _subcategories_arr[i], x, text_y_position - subcategories_font_size );
text_y_position += subcategories_font_size;
}}if ( current_radius >= selected_radius )
{context.font = "12px " + font_name + ", 'Dosis'";
if ( _notes != "" && functionality_obj.show_notes )
{if ( data_points_status != "GROW" && functionality_obj.show_notes )
{context.fillText( functionality_obj.shownotes_label, x, text_y_position - 16 );
}source_link_position = [];
}else if ( _bubble_link )
{context.fillText( functionality_obj.opensource_label, x, text_y_position -16 );
source_link_position = [ x, text_y_position - 32 ];
}}}else
{var notes_font_size = 13;
var text_y_position = y + notes_font_size - (notes_arr.length * notes_font_size / 2);
context.font = notes_font_size + "px " + font_name + ", 'Dosis'";
for ( var i = 0; i < notes_arr.length; i++ )
{context.fillText( notes_arr[i], x, text_y_position );
text_y_position += notes_font_size;
}if ( _bubble_link )
{context.fillText( functionality_obj.opensource_label, x, text_y_position + 8 );
source_link_position = [ x, text_y_position - 16 ];
}}}void getMyTextColour()
{get_my_text_colour = false;
if ( colour_bubbles_by != "value" )
{text_colour = checkTextColourForHexValue( bubble_colour );
}else
{if ( !_onetowatch )
{var difference = 9999;
var new_difference;
var closest_colour;
for ( var i=0; i < bubble_colours_arr.length; i++ )
{new_difference = Math.abs( bubble_colours_arr[i].position - _primaryvalue);
if ( new_difference < difference )
{difference = new_difference;
closest_colour = bubble_colours_arr[i].colour;
}}text_colour = checkTextColourForHexValue( closest_colour );
}else
{text_colour = checkTextColourForHexValue( bubble_one_to_watch_fill );
}}}void setBubbleColour()
{
if ( colour_bubbles_by == "type" )
{if ( _onetowatch && ( functionality_obj.onetowatch == "type_only" || functionality_obj.onetowatch == "always" ))
{bubble_colour = bubble_one_to_watch_fill;
}else
{bubble_colour = type_colour;
}}else
{if ( _onetowatch && ( functionality_obj.onetowatch == "primary_value_only" || functionality_obj.onetowatch == "always" ))
{bubble_colour = bubble_one_to_watch_fill;
}else
{bubble_colour = bubble_linear_gradient;
}}get_my_text_colour = true;
}void setBubbleSizeParam()
{active_radius = getMyVarByName( this, "normalised_" + bubble_size_param_name );
selected_radius = Math.max( 200, active_radius + 10 );
if ( name_arr.length == 0 ) setupText();
if ( active == true )
{target_radius = active_radius;
shuffling_radius = active_radius;
current_radius = inactive_radius;
}else
{target_radius = inactive_radius;
}TweenLite.to( this, 1, { current_radius: target_radius, ease: Elastic.easeOut, delay: ( 2 + random(0.5)) - (target_radius / maximum_radius) * 2, onComplete: function() { data_points_status = "SHUFFLE" }, easeParams:[0.2, 0.6] });
getInitialPosition();
}void setActive( boolean _active )
{active = _active;
show_text = _active
target_radius = ( active == true ) ? active_radius : inactive_radius;
TweenLite.to( this, 0.5, { current_radius: target_radius, ease: Expo.easeOut, delay: 0.1 });
if ( !active ) resetBubble();
}void mouseOver()
{if ( active == true && target_radius != selected_radius )
{status = "OVER";
stroke = "rgba(255, 255, 255, 0.9)";
stroke_width = 10;
target_radius = selected_radius;
base_x = x;
base_y = y;
int new_x = x;
int new_y = y;

	if ( x < 100 )
	{
		new_x = x + 100;
	}
	else if ( x > ( stage_size[0] - 100 ) )
	{
		new_x = x - 100;
	}

	//dbg( y + " / " + stage_size[1])
	if ( y > stage_size[1] - 100)
	{
		new_y = y - 150;
	}

	TweenLite.to( this, 0.7, { x: new_x, y: new_y, current_radius: target_radius, ease: Expo.easeInOut, delay: 0.4, onComplete: trackMouseOver });

}}void trackMouseOver()
{_gaq.push(['_trackEvent', 'BubbleInteraction', 'MouseOver', _name]);
dbg("tracking event: BubbleInteraction / MouseOver : " + _name);
}void mouseOut()
{if ( active == true && target_radius != active_radius )
{target_radius = active_radius;
if ( device_type == "is_desktop" )
{TweenLite.killTweensOf( this );
TweenLite.to( this, 1, { x: base_x, y: base_y, current_radius: target_radius, ease: Elastic.easeOut, easeParams:[0.2, 0.6] });
}else
{current_radius = target_radius;
x = base_x;
}resetBubble();
source_link_position = [];
}}void mouseDown( int mouse_x, int mouse_y )
{if ( current_radius >= selected_radius )
{if (( status == "OVER" && _notes ) && functionality_obj.show_notes )
{status = "NOTES";
stroke = bubble_colour;
stroke_width = 5;
bubble_colour = "rgba(255, 255, 255, 0.8)";
text_colour = "black";
}else if (( status == "NOTES" || !_notes ) || !functionality_obj.show_notes )
{if ( _bubble_link )
{if ( Math.abs( mouse_x - source_link_position[0] ) < 50 && Math.abs( mouse_y - source_link_position[1] ) < 20 )
{window.open( _bubble_link,'_blank');
}}status = "OVER";
setBubbleColour();
stroke = "rgba(255, 255, 255, 0.8)";
stroke_width = 10;
get_my_text_colour = true;
}}}void resetBubble()
{status = "OFF";
stroke = false;
setBubbleColour();
get_my_text_colour = true;
}}void allDataPointsAdded()
{normaliseBubbleSizes();
}
void normaliseBubbleSizes()
{
normaliseMetric( "_metric_001" );
normaliseMetric( "_metric_002" );
normaliseMetric( "_metric_003" );
normaliseMetric( "_metric_004" );
}function normaliseMetric( metric )
{var metric_obj = getMetricLimits( metric );
var max_area = ( maximum_radius * maximum_radius ) * Math.PI;
var min_area = ( minimum_radius * minimum_radius ) * Math.PI;
var normalised_area;
var datapoint;
var total_bubble_area = 0;
for ( var i = 0; i < datapoints_arr.length; i++ )
{datapoint = datapoints_arr[i];
normalised_area = (( datapoint[ metric ] - metric_obj.min) / ( metric_obj.max - metric_obj.min )) * max_area;
datapoint.normalised_area = normalised_area;
total_bubble_area += normalised_area;
}var total_stage_area = stage_size[0] * stage_size[1];
var bubble_area_to_stage_area_ratio = ( total_stage_area / 2 ) / total_bubble_area;
for ( var j = 0; j < datapoints_arr.length; j++ )
{datapoint = datapoints_arr[j];
datapoint["normalised" + metric ] = sqrt( ( ( min_area + datapoint.normalised_area ) * bubble_area_to_stage_area_ratio ) / Math.PI );
}}function getMetricLimits( metric )
{var sorted_array = sortArrayBy( datapoints_arr, metric, "number", "ascending" );
var metric_obj = { id: metric, min: sorted_array[0][metric], max: sorted_array[ sorted_array.length - 1 ][metric] };
return metric_obj;
}function shuffleDataPoints()
{var datapoint_obj;
var cloned_datapoints_arr = datapoints_arr.slice( 0 );
var n_points = cloned_datapoints_arr.length;
var overlaps = 0;
var at_rest = true;
shuffle_duration ++;
for ( var i = 0; i < n_points; i++ )
{datapoint_obj = cloned_datapoints_arr.splice( 0, 1 )[ 0 ];
repelBubbles( datapoint_obj, cloned_datapoints_arr );
}
at_rest = setBubblePositions();
if ( data_points_status == "SHUFFLE" && at_rest || shuffle_duration > shuffle_duration_limit)
{data_points_status = "STEADY";
for ( var i = 0; i < n_points; i++ ) datapoints_arr[i].get_my_text_colour = true;
if ( show_filter_button.checked && functionality_obj.app_status == "SHOWING_VIZ" )
{var filter_panel = $("#viz-filter-panel");
filter_panel.css('display', 'block');
TweenLite.to( filter_panel, 1, { css:{ opacity: 1 }, delay: 0.5 });
}}}function repelBubbles( point_A, cloned_datapoints_arr )
{var point_B;
var n_points;
var radius_A;
var radius_B;
var total_radius;
var total_distance;
var dX;
var dY;
var ratio_A;
var ratio_B;
var angle_A_B;
var spring;
var vX;
var vY;
var multiplier = 1;
radius_A = point_A.shuffling_radius;
n_points = cloned_datapoints_arr.length;
for ( var i = 0; i < n_points; i++ )
{point_B = cloned_datapoints_arr[i];
radius_B = point_B.shuffling_radius;
total_radius = radius_A + radius_B;
dX = point_B.x - point_A.x;
dY = point_B.y - point_A.y;
total_distance = sqrt( sq( dX ) + sq( dY ));
bubble_overlap_allowed = ( ratio_A > 25 && ratio_b > 25 ) ? total_radius * 0.3 : total_radius * 0.1;
if ( abs( total_distance ) < ( total_radius - bubble_overlap_allowed ))
{ratio_A = radius_A / ( radius_A + radius_B );
ratio_B = 1 - ratio_A;
angle_A_B = atan2( dY, dX );
spring = 1.2 - ( total_distance / total_radius );
vX = cos( angle_A_B );
vY = sin( angle_A_B );
point_A.vX -= (vX * spring) * ratio_B;
point_A.vY -= (vY * spring) * ratio_B;
point_B.vX += (vX * spring) * ratio_A;
point_B.vY += (vY * spring) * ratio_A;
}}checkAgainstDividingLines( point_A );
}function checkAgainstDividingLines( datapoint )
{var point_radius = datapoint.active_radius;
for ( var j = 0, dividingline_obj; dividingline_obj = dividinglines_arr[j]; j++)
{if ( abs( datapoint.y - dividingline_obj.y ) <= ( point_radius + 10 ))
{if ( datapoint.y >= dividingline_obj.y )
{datapoint.y = dividingline_obj.y + point_radius + 10;
datapoint.vY = 0;
}else
{datapoint.y = dividingline_obj.y - point_radius - 10;
datapoint.vY  = 0;
}}}}boolean setBubblePositions()
{int n_points;
DataPoint datapoint;
int point_radius;
float friction = 0.9;
int side_buffer = 30;
n_points = datapoints_arr.length;
boolean at_rest = true;
for ( var i = 0; i < n_points; i++ )
{datapoint = datapoints_arr[i];
point_radius = datapoint.active_radius;
datapoint.x += datapoint.vX;
datapoint.y += datapoint.vY;
datapoint.vX *= friction;
datapoint.vY *= friction;
if ((datapoint.x - point_radius ) < 50 )
{datapoint.x = point_radius + 50;
}else if (datapoint.x + point_radius  > stage_size[0] - 50 )
{datapoint.x = ( stage_size[0] - 50 ) - point_radius;
}if ((datapoint.y - point_radius ) < vertical_buffer_amount )
{datapoint.y = point_radius + vertical_buffer_amount;
}else if ((datapoint.y + point_radius ) > stage_size[1] - vertical_buffer_amount )
{datapoint.y = stage_size[1] - point_radius - vertical_buffer_amount;
}if ( abs( datapoint.vX ) > 0.1 || abs( datapoint.vY ) > 0.1 ) at_rest = false;
}return at_rest;
}void setBubbleColourStyle()
{for ( var i = 0; i < datapoints_arr.length; i ++ )
{datapoints_arr[i].setBubbleColour();
}}
class DividingLine
{float _position;
String _upper_label;
String _lower_label;
var y;
var upper_text_width;
var upper_text_height = base_font_size;
var upper_text_position = [];
var lower_text_width;
var lower_text_height = upper_text_height;
var lower_text_position = [];
DividingLine( float _position, String _upper_label, String _lower_label )
{this._position = _position;
this._upper_label = _upper_label;
this._lower_label = _lower_label;
}void getPosition()
{y = ( stage_size[1] - vertical_buffer_amount ) - (( _position - scale_obj._minimum ) / ( scale_obj._maximum - scale_obj._minimum )) * ( stage_size[1] - ( vertical_buffer_amount * 2 ));
context.font = "11px " + font_name + ", 'Dosis'";
_lower_label = _lower_label;
upper_text_width = context.measureText( _upper_label ).width;
upper_text_position = [ stage_size[0] / 2, y - (11)];
lower_text_width = context.measureText( _lower_label ).width;
lower_text_position = [ stage_size[0] / 2, y + 10 ];
}void draw()
{pushMatrix();
fill( 0 );
stroke( 100, 100, 100 );
drawDottedLine( 10, y, stage_size[0], y, "#333" );
drawCanvasRoundedRectangle( upper_text_position[0] - ( upper_text_width / 2 ) - 5, upper_text_position[1] - 10, upper_text_width + 10, 20, 5 );
context.fillStyle = "black";
context.textAlign = 'center';
context.textBaseline = "middle";
context.font = "11px " + font_name + ", 'Dosis'";
context.fillText( _upper_label, upper_text_position[0], upper_text_position[1] );
context.fillStyle = "grey";
context.textAlign = 'center';
context.textBaseline = "middle";
context.font = "11px " + font_name + ", 'Dosis'";
context.fillText( _lower_label, lower_text_position[0], lower_text_position[1] );
popMatrix();
}}
void chooseBubbleSizeParam( String _bubble_size_param_name )
{if ( _bubble_size_param_name ) bubble_size_param_name = _bubble_size_param_name;
for ( int i = 0; i < datapoints_arr.length; i=i+1 )
{datapoints_arr[i].setBubbleSizeParam();
}datapoints_arr = sortArrayBy( datapoints_arr, "_" + bubble_size_param_name, "number", "descending", false );
shuffle_duration = 0;
data_points_status = "GROW";
}
void bubbleMouseDown( DataPoint _datapoint, int mouse_x, int mouse_y )
{_datapoint.mouseDown( mouse_x, mouse_y );
}