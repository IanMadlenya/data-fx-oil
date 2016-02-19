# ������� ��� ��������� ���������� ��������� �����
# 15:20 16.04.2015

# ��������������� ������� ��� ��������� ���� ��� ����� �� ����� ������� ���������� ����
year = function(x){as.numeric(format(time(x), format = "%Y"))}


month.frame = function(x)
# ������� ��� ��������� ������� ���������� � �������� ������� 
# �������� x - ��������� ���

   {
	x1 = round(mold(x,period = "m", position =  "start"), 2)
	x2 = round(mold(x,period = "m", position =  "all",    using.function = "mean"), 2)
	x3 = round(mold(x,period = "m", position =  "end"),   2)

	year = as.numeric(time(x1) %/% 1) 			        # %/% - ��������� ������ 
	month = round(12 * (as.numeric(time(x1) %% 1)),0)+1 # %% - ������� �� �������

	date = paste("1",month,year,sep="-")
	date = as.Date(date, "%d-%m-%Y")

	# ������� ��� ���������� � ����� (� ������)
		w = data.frame(date,year,month,x1,x2,x3)
		colnames(w)[4:6] = c("start", "mean", "end")
		
	# ���������� �������� ������� ���, ����� ����� ������
		w = w[dim(w)[1]:1,]

	return(w)
}

mold = function(ts, period = "m", position =  "all", using.function = "mean")
# Aggregate time series accoring to period (a, q, or m - annual, quarterly 
# and monthly), observation position (all, start , end) and function (mean, max, min, sd)

{
	# Use zoo library for time series
	library(zoo)
	freq = c(1,4,12)

	# ����� ������������ ��������� ����� ������ ��� ������������� 
	an.1 = c("y", "q", "m")
	period.choice = which(an.1 == period)
	aggregate.by = switch(period.choice,
		year(ts), 
		as.yearqtr(time(ts)),
		as.yearmon(time(ts))   )

	# ����� �� ��������� ����� ���������� ������ ��� ��������� ����� �� ��������, � ����������� �� ������
	# ��� ����������� ��� �����
	an.2 = c("all", "start", "end")
	subset.index = switch (which (an.2 == position),
		aggregate.by == aggregate.by, # all TRUE
		!duplicated(aggregate.by),
		!duplicated(aggregate.by, fromLast = TRUE) )

	# �� ������� subset.index ��������� � ts � aggregate.by 
	aggregate.by = aggregate.by[subset.index]
	ts = ts[subset.index]

	# ���������� ������� �������������
	s = aggregate(ts, aggregate.by, FUN = using.function)
	# aggregated = as.numeric(aggregate(ts, aggregate.by, FUN = using.function))

	# ��������� �������� ��� ������� � ��� ts
	# ������� ������ ��������� ��� ���� � ��� ������ ������
	# start.val = switch (period.choice, start.year, c(start.year, start.qtr), c(start.year, start.month))
	# s = ts(aggregated, start = start.val, frequency = freq[period.choice])
		
	return(s)

}

