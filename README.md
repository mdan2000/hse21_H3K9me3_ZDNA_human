# hse21_H3K9me3_ZDNA_human
Репозиторий для проекта по майнору "Биоинформатика"

# Отчёт
---
# Анализ пиков гистоновой метки
Прежде всего нам нужно создать этот репозиторий (как не странно) с непустым README.md и установить свои credential на рабочем сервере:
```
git config --global user.name "mdan2000"
git config --global user.email "mdan_2000@mail.ru"
git config --global core.autocrlf input
git config --global color.ui auto
```
После этого делаем 
```
git clone https://github.com/mdan2000/hse21_H3K9me3_ZDNA_human
```
чтобы притянуть репозиторий на рабочий сервер.
Я выбрал организм human с гистоновой маркой H3K9me3. Тип клеток K562 был не занят, поэтому взял его. Выбрал два bed файла: ENCFF963GZJ и ENCFF567HEH. Скачаем их на наш рабочий сервер:
```
wget https://www.encodeproject.org/files/ENCFF963GZJ/@@download/ENCFF963GZJ.bed.gz
zcat ENCFF963GZJ.bed.gz  |  cut -f1-5 > H3K9me3_K562.ENCFF963GZJ.hg38.bed
wget https://www.encodeproject.org/files/ENCFF567HEH/@@download/ENCFF567HEH.bed.gz
zcat ENCFF567РУР.bed.gz  |  cut -f1-5 > H3K9me3_K562.ENCFF567HEH.hg38.bed
```
Они скачаны в формате hg38, поэтому скачаем нужный файл для liftOver для конвертации:
```
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz
```
Теперь, собственно, воспользуемся конвертацией:
```
liftOver   H3K9me3_K562.ENCFF963GZJ.hg38.bed   hg38ToHg19.over.chain.gz   H3K9me3_K562.ENCFF963GZJ.hg19.bed   H3K9me3_K562.ENCFF963GZJ.unmapped.bed
liftOver   H3K9me3_K562.ENCFF567HEH.hg38.bed   hg38ToHg19.over.chain.gz   H3K9me3_K562.ENCFF567HEH.hg19.bed   H3K9me3_K562.ENCFF567HEH.unmapped.bed
```

Загружаем на гитхаб с помощью команд:
```
git add все_что_мы_насоздавали
git commit -m "upload bed files hg19 and hg38"
git push
```

Создаём гистограммы распределений длины с помощью [скрипта](src/len_hist.r)

[Распределение для ENCFF567HEH.hg19](results/len_hist.H3K9me3_K562.ENCFF567HEH.hg19.pdf)

[Распределение для ENCFF567HEH.hg38](results/len_hist.H3K9me3_K562.ENCFF567HEH.hg38.pdf)

[Распределение для ENCFF963GZJ.hg19](results/len_hist.H3K9me3_K562.ENCFF963GZJ.hg19.pdf)

[Распределение для ENCFF963GZJ.hg38](results/len_hist.H3K9me3_K562.ENCFF963GZJ.hg38.pdf)

Количество пиков:

Для ENCFF567HEH.hg38 - 24100

Для ENCFF567HEH.hg19 - 23889 (потеряли 201 пик)

Для ENCFF963GZJ.hg38 - 25513

Для ENCFF963GZJ.hg19 - 25411 (потеряли 102 пика)

Выкидываем лишние геномы: для ENCFF67.HEH я взял геномы длиной меньше 1300, для 963GZJ длиной меньше 1000. Фильтруем с помощью [скрипта](src/filter_peaks.r)
После фильтрации получились такие распределения:

[Распределение для ENCFF567HEH](results/filter_peaks.H3K9me3_K562.ENCFF567HEH.hg19.filtered.hist.pdf)

[Распределение для ENCFF963GZJ](results/filter_peaks.H3K9me3_K562.ENCFF963GZJ.hg19.filtered.hist.pdf)

Рисуем pie-chart график с помощью [скрипта](src/chep_seeker.r):

[ENCFF963GZJ](results/chip_seeker.H3K9me3_K562.ENCFF963GZJ.hg19.filtered.plotAnnoPie.png)

[ENCFF567HEH](results/chip_seeker.H3K9me3_K562.ENCFF567HEH.hg19.filtered.plotAnnoPie.png)

Загружаем наши полученные отфильтрованные bed файлы на гитхаб (просто upload files на нашем пк).

На рабочем сервере делаем git pull, у нас подгрузились файлы с отфильтрованными .bed файлами.

Далее, на сервере с помощью
```
git pull
```
притягиваем загруженные отфильтрованные .bed файлы
Объединяем их с помощью команды
```
cat  *.filtered.bed | sort -k1,1 -k2,2n | bedtools merge > H3K9me3_K562.merge.hg19.bed
```
Загружаем на github с помощью add commit pull, как раньше, визиуализируем в геномном бразуере:
[Браузер](results/ucsc1.PNG)

---
# Анализ вторичной структуры ДНК
Скачиваем к себе и на рабочий сервер на рабочий сервер DeepZ.bed:
```
wget https://raw.githubusercontent.com/Nazar1997/DeepZ/master/annotation/DeepZ.bed
```
С помощью нам уже знакомого [скрипта](src/len_hist.r) строим распределение пиков

[Распределение DeepZ](results/len_hist.DeepZ.pdf)

С помощью тоже знакомого [скрипта](src/chep_seeker.r) получаем информацию о расположении участков:

[DeepZ](results/chip_seeker.DeepZ.plotAnnoPie.png)

---

# Анализ пересечений гистоновой метки и структуры ДНК

С помощью команды 
```
bedtools intersect -a DeepZ.bed -b H3K9me3_K562.merge.hg19.bed > H3K9me3_K562.intersect_with_DeepZ.bed
```
also git add commit push

Визиуализируем в геномном браузере полученные результаты:

[Сессия](results/my_session)

[Скрин](results/ucsc2.PNG)

Участки: chr1:3,785,165-3,785,265

Проводим анализ с нашим [файлом](data/H3K4me3_A549.intersect_with_DeepZ.genes_uniq.txt)

Получаем [результат](results/pant.PNG) (значимых результатов нет)
