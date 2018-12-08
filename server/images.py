import pytesser3
from PIL import Image
import os
#print os.getcwd()
image = Image.open('C:\Users\pc\Desktop\qkyunwei\static\jpeg\code.jpeg')

print(pytesser3.image_file_to_string(image,cleanup='cleanup_scratch_flag'))
