@tool
extends TextEdit

const MAX_LINES := 10
const MIN_LINES := 2
var line_height := 0

func _ready() -> void:
	# Ensure fit_content_height is on initially
	scroll_fit_content_height = true
	
	# Calculate approximate line height based on current font
	# We use a dummy string to get the accurate height including spacing
	line_height = get_line_height()
	
	# Connect the signal to monitor text changes
	text_changed.connect(_on_text_changed)
	
	# Initialize size
	_update_height()

func _on_text_changed() -> void:
	_update_height()

func _update_height() -> void:
	var current_lines = get_line_count()
	
	# Note: get_line_count() counts logical lines (newline characters).
	# If you need to count visual wrapped lines, the logic is more complex 
	# and requires measuring string width against control width.
	
	if current_lines > MAX_LINES:
		# Cap height and enable scrolling
		scroll_fit_content_height = false
		custom_minimum_size.y = line_height * MAX_LINES
		# Optional: Scroll to bottom if desired
		# scroll_vertical = INF 
	elif current_lines < MIN_LINES:
		# Ensure it never shrinks below minimum (handled by Custom Minimum Size usually)
		scroll_fit_content_height = true
		custom_minimum_size.y = line_height * MIN_LINES
	else:
		# Between 2 and 10 lines: keep expanding
		scroll_fit_content_height = true
		# Reset custom min size to allow natural growth or set explicitly
		custom_minimum_size.y = line_height * current_lines   
