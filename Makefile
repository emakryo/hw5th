CC = ghdl
OPT = -fexplicit --ieee=synopsys
STOPTIME = 2000ns
RUNOPT = --stop-time=$(STOPTIME)
SOURCE = r232c.vhd u232c.vhd top.vhd top_tb.vhd
TARGET = top_tb.vcd

all: $(TARGET)
	gtkwave $(TARGET) &

$(TARGET): $(SOURCE)
	$(CC) -a $(OPT) $(SOURCE); \
	$(CC) -e $(OPT) $(TARGET:.vcd=); \
	$(CC) -r $(OPT) $(TARGET:.vcd=) --vcd=$(TARGET) $(RUNOPT)

clean:
	rm -rf *.cf *.vcd
