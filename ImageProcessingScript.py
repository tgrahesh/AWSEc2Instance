from PIL import Image, ImageDraw, ImageFont
#  Load the input image
input_image_path = "/app/InputImage.jpeg"
output_image_path = "/app/output.jpeg"

# Open the image using Pillow
image = Image.open(input_image_path)

# Resize the image to a specific width and height
new_size = (800, 400)
resized_image = image.resize(new_size)

# Add a watermark to the image
watermark_text = "Watermark"
draw = ImageDraw.Draw(resized_image)
#font = ImageFont.truetype("arial.ttf", 36)
draw.text((10, 10), watermark_text, fill=(255, 255, 255))

# Save the processed image to the output location
resized_image.save(output_image_path)

print(f"Image processing complete. Saved to {output_image_path}")
