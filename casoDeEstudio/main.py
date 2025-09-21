# !pip install ultralytics
# !pip -q install kaggle
import kagglehub
import os, shutil

farzadnekouei_top_view_vehicle_detection_image_dataset_path = kagglehub.dataset_download('farzadnekouei/top-view-vehicle-detection-image-dataset')

print('Data source import complete.')

# Instalar Kaggle CLI

# Asegúrate de que kaggle.json está en /content
KAGGLE_JSON_PATH = "/content/kaggle.json"
assert os.path.exists(KAGGLE_JSON_PATH), "⚠️ Sube tu kaggle.json a /content primero"

# Configurar credenciales
!mkdir -p ~/.kaggle
shutil.copy(KAGGLE_JSON_PATH, "/root/.kaggle/kaggle.json")
os.chmod("/root/.kaggle/kaggle.json", 0o600)

# Muestra datasets que coincidan con el nombre del notebook
!kaggle datasets list -s "top-view-vehicle-detection-image-dataset"
# (Si no aparece, prueba una búsqueda más amplia)
!kaggle datasets list -s "vehicle detection image dataset"

PROJECT_DIR = "/content/drive/MyDrive/proyectos/traffic-density-estimation"

DATASET_ID = "farzadnekouei/top-view-vehicle-detection-image-dataset"

!mkdir -p "{PROJECT_DIR}/kaggle"
!kaggle datasets download -d {DATASET_ID} -p "{PROJECT_DIR}/kaggle" --force
!unzip -o "{PROJECT_DIR}/kaggle/*.zip" -d "{PROJECT_DIR}/kaggle"

!find "{PROJECT_DIR}/kaggle" -maxdepth 3 -type f | grep "sample_image.jpg"

!nvidia-smi

# Disable warnings in the notebook to maintain clean output cells
import warnings
warnings.filterwarnings('ignore')

# Import necessary libraries
import os
import shutil
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import cv2
import yaml
from PIL import Image
from ultralytics import YOLO
from IPython.display import Video

# Configure the visual appearance of Seaborn plots
sns.set(rc={'axes.facecolor': '#ffc430'}, style='darkgrid')

# Load a pretrained YOLOv8n model from Ultralytics
model = YOLO('yolov8n.pt')

import kagglehub
farzadnekouei_top_view_vehicle_detection_image_dataset_path = kagglehub.dataset_download('farzadnekouei/top-view-vehicle-detection-image-dataset')

print('Data source import complete.')

image_path = f"{PROJECT_DIR}/kaggle/Vehicle_Detection_Image_Dataset/sample_image.jpg"

results = model.predict(source=image_path, imgsz=640, conf=0.5)
im = results[0].plot(line_width=2)

import cv2, matplotlib.pyplot as plt
im = cv2.cvtColor(im, cv2.COLOR_BGR2RGB)
plt.figure(figsize=(12,9))
plt.imshow(im)
plt.axis('off')
plt.title('Detecciones en sample_image.jpg')
plt.show()

## STEP 3 | Dataset Exploration

# Define the dataset_path
dataset_path = f"{PROJECT_DIR}/kaggle/Vehicle_Detection_Image_Dataset"

# Set the path to the YAML file
yaml_file_path = os.path.join(dataset_path, f"{PROJECT_DIR}/kaggle/Vehicle_Detection_Image_Dataset/data.yaml")

# Load and print the contents of the YAML file
with open(yaml_file_path, 'r') as file:
    yaml_content = yaml.load(file, Loader=yaml.FullLoader)
    print(yaml.dump(yaml_content, default_flow_style=False))

# Set paths for training and validation image sets
train_images_path = os.path.join(dataset_path, 'train', 'images')
valid_images_path = os.path.join(dataset_path, 'valid', 'images')

# Initialize counters for the number of images
num_train_images = 0
num_valid_images = 0

# Initialize sets to hold the unique sizes of images
train_image_sizes = set()
valid_image_sizes = set()

# Check train images sizes and count
for filename in os.listdir(train_images_path):
    if filename.endswith('.jpg'):
        num_train_images += 1
        image_path = os.path.join(train_images_path, filename)
        with Image.open(image_path) as img:
            train_image_sizes.add(img.size)

# Check validation images sizes and count
for filename in os.listdir(valid_images_path):
    if filename.endswith('.jpg'):
        num_valid_images += 1
        image_path = os.path.join(valid_images_path, filename)
        with Image.open(image_path) as img:
            valid_image_sizes.add(img.size)

# Print the results
print(f"Number of training images: {num_train_images}")
print(f"Number of validation images: {num_valid_images}")

# Check if all images in training set have the same size
if len(train_image_sizes) == 1:
    print(f"All training images have the same size: {train_image_sizes.pop()}")
else:
    print("Training images have varying sizes.")

# Check if all images in validation set have the same size
if len(valid_image_sizes) == 1:
    print(f"All validation images have the same size: {valid_image_sizes.pop()}")
else:
    print("Validation images have varying sizes.")

# List all jpg images in the directory
image_files = [file for file in os.listdir(train_images_path) if file.endswith('.jpg')]

# Select 8 images at equal intervals
num_images = len(image_files)
selected_images = [image_files[i] for i in range(0, num_images, num_images // 8)]

# Create a 2x4 subplot
fig, axes = plt.subplots(2, 4, figsize=(20, 11))

# Display each of the selected images
for ax, img_file in zip(axes.ravel(), selected_images):
    img_path = os.path.join(train_images_path, img_file)
    image = Image.open(img_path)
    ax.imshow(image)
    ax.axis('off')

plt.suptitle('Sample Images from Training Dataset', fontsize=20)
plt.tight_layout()
plt.show()

## Step 4 | Fine-Tuning YOLOv8

# Train the model on our custom dataset
results = model.train(
    data=yaml_file_path,     # Path to the dataset configuration file
    epochs=150,              # Number of epochs to train for
    imgsz=640,               # Size of input images as integer
    device=0,                # Device to run on, i.e. cuda device=0
    patience=50,             # Epochs to wait for no observable improvement for early stopping of training
    batch=32,                # Number of images per batch
    optimizer='auto',        # Optimizer to use, choices=[SGD, Adam, Adamax, AdamW, NAdam, RAdam, RMSProp, auto]
    lr0=0.0001,              # Initial learning rate
    lrf=0.1,                 # Final learning rate (lr0 * lrf)
    dropout=0.1,             # Use dropout regularization
    seed=0                   # Random seed for reproducibility
)

## Step 5 | Model Performance Evaluation

post_training_files_path = '/content/runs/detect/train'

# List the files in the directory
!ls {post_training_files_path}


# Define a function to plot learning curves for loss values
def plot_learning_curve(df, train_loss_col, val_loss_col, title):
    plt.figure(figsize=(12, 5))
    sns.lineplot(data=df, x='epoch', y=train_loss_col, label='Train Loss', color='#141140', linestyle='-', linewidth=2)
    sns.lineplot(data=df, x='epoch', y=val_loss_col, label='Validation Loss', color='orangered', linestyle='--', linewidth=2)
    plt.title(title)
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.show()

# Create the full file path for 'results.csv' using the directory path and file name
results_csv_path = os.path.join(post_training_files_path, 'results.csv')

# Load the CSV file from the constructed path into a pandas DataFrame
df = pd.read_csv(results_csv_path)

# Remove any leading whitespace from the column names
df.columns = df.columns.str.strip()

# Plot the learning curves for each loss
plot_learning_curve(df, 'train/box_loss', 'val/box_loss', 'Box Loss Learning Curve')
plot_learning_curve(df, 'train/cls_loss', 'val/cls_loss', 'Classification Loss Learning Curve')
plot_learning_curve(df, 'train/dfl_loss', 'val/dfl_loss', 'Distribution Focal Loss Learning Curve')

# Construct the path to the normalized confusion matrix image
confusion_matrix_path = os.path.join(post_training_files_path, 'confusion_matrix_normalized.png')

# Read the image using cv2
cm_img = cv2.imread(confusion_matrix_path)

# Convert the image from BGR to RGB color space for accurate color representation with matplotlib
cm_img = cv2.cvtColor(cm_img, cv2.COLOR_BGR2RGB)

# Display the image
plt.figure(figsize=(10, 10), dpi=120)
plt.imshow(cm_img)
plt.axis('off')
plt.show()

# Construct the path to the best model weights file using os.path.join
best_model_path = os.path.join(post_training_files_path, 'weights/best.pt')

# Load the best model weights into the YOLO model
best_model = YOLO(best_model_path)

# Validate the best model using the validation set with default parameters
metrics = best_model.val(split='val')

# Convert the dictionary to a pandas DataFrame and use the keys as the index
metrics_df = pd.DataFrame.from_dict(metrics.results_dict, orient='index', columns=['Metric Value'])

# Display the DataFrame
metrics_df.round(3)

## Step 6 | Model Inference & Generalization Assessment

# Define the path to the validation images
valid_images_path = os.path.join(dataset_path, 'valid', 'images')

# List all jpg images in the directory
image_files = [file for file in os.listdir(valid_images_path) if file.endswith('.jpg')]

# Select 9 images at equal intervals
num_images = len(image_files)
selected_images = [image_files[i] for i in range(0, num_images, num_images // 9)]

# Initialize the subplot
fig, axes = plt.subplots(3, 3, figsize=(20, 21))
fig.suptitle('Validation Set Inferences', fontsize=24)

# Perform inference on each selected image and display it
for i, ax in enumerate(axes.flatten()):
    image_path = os.path.join(valid_images_path, selected_images[i])
    results = best_model.predict(source=image_path, imgsz=640, conf=0.5)
    annotated_image = results[0].plot(line_width=1)
    annotated_image_rgb = cv2.cvtColor(annotated_image, cv2.COLOR_BGR2RGB)
    ax.imshow(annotated_image_rgb)
    ax.axis('off')

plt.tight_layout()
plt.show()

# Path to the image file
sample_image_path = f"{PROJECT_DIR}/kaggle/Vehicle_Detection_Image_Dataset/sample_image.jpg"

# Perform inference on the provided image using best model
results = best_model.predict(source=sample_image_path, imgsz=640, conf=0.7)

# Annotate and convert image to numpy array
sample_image = results[0].plot(line_width=2)

# Convert the color of the image from BGR to RGB for correct color representation in matplotlib
sample_image = cv2.cvtColor(sample_image, cv2.COLOR_BGR2RGB)

# Display annotated image
plt.figure(figsize=(20,15))
plt.imshow(sample_image)
plt.title('Detected Objects in Sample Image by the Fine-tuned YOLOv8 Model', fontsize=20)
plt.axis('off')
plt.show()

# Define the path to the sample video in the dataset
dataset_video_path = f"{PROJECT_DIR}/kaggle/Vehicle_Detection_Image_Dataset/sample_video.mp4"

# Define the destination path in the working directory
video_path = f"{PROJECT_DIR}/kaggle/working/sample_video.mp4"


# Copy the video file from its original location in the dataset to the current working directory in Kaggle for further processing
shutil.copyfile(dataset_video_path, video_path)

# Initiate vehicle detection on the sample video using the best performing model and save the output
best_model.predict(source=video_path, save=True)

# Convert the .avi video generated by the YOLOv8 prediction to .mp4 format for compatibility with notebook display
!ffmpeg -y -loglevel panic -i /content/runs/detect/predict/sample_video.avi processed_sample_video.mp4

# Embed and display the processed sample video within the notebook
Video("processed_sample_video.mp4", embed=True, width=960)