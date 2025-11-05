# plot1.R
# Recreate Plot 1: Histogram of Global Active Power (kilowatts)
# Output: plot1.png (480x480)

# ---- Download & prepare data (idempotent) ----
zip_url  <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- "household_power_consumption.zip"
txt_file <- "household_power_consumption.txt"

if (!file.exists(txt_file)) {
  if (!file.exists(zip_file)) {
    download.file(zip_url, destfile = zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# ---- Read only the needed dates (simple, portable approach) ----
# The file encodes missing values as '?'. Dates are dd/mm/yyyy.
dat <- read.table(
  txt_file,
  header = TRUE,
  sep = ";",
  na.strings = "?",
  colClasses = c("character","character",rep("numeric",7))  # keep Date/Time as char
)

dat <- subset(dat, Date %in% c("1/2/2007","2/2/2007"))

# (Plot 1 doesn’t require time parsing, so we skip creating POSIXct here.)

# ---- Create the PNG (480x480) and draw the histogram ----
png("plot1.png", width = 480, height = 480)
hist(dat$Global_active_power,
     col  = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()
