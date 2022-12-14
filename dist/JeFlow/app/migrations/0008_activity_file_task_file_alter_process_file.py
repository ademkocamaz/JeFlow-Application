# Generated by Django 4.1.3 on 2022-11-29 09:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0007_process_file_alter_state_color'),
    ]

    operations = [
        migrations.AddField(
            model_name='activity',
            name='file',
            field=models.FileField(blank=True, null=True, upload_to='activity_files/%Y/%m/%d/', verbose_name='Dosya'),
        ),
        migrations.AddField(
            model_name='task',
            name='file',
            field=models.FileField(blank=True, null=True, upload_to='task_files/%Y/%m/%d/', verbose_name='Dosya'),
        ),
        migrations.AlterField(
            model_name='process',
            name='file',
            field=models.FileField(blank=True, null=True, upload_to='process_files/%Y/%m/%d/', verbose_name='Dosya'),
        ),
    ]
