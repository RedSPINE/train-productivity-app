extends RichTextLabel 

func meta_clicked(meta):
	OS.shell_open(meta)

func _on_meta_clicked(meta):
	meta_clicked(meta)
