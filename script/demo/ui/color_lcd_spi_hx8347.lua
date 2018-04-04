--[[
ģ�����ƣ�hx 8347����оƬ��������
ģ�鹦�ܣ���ʼ��оƬ����
ģ������޸�ʱ�䣺2017.12.10
]]

--[[
ע�⣺���ļ������ã�Ӳ����ʹ�õ��Ǳ�׼��SPI���ţ�����LCDר�õ�SPI����
disp��Ŀǰ��֧��SPI�ӿڵ�����Ӳ������ͼ���£�
Airģ��			LCD
GND-------------��
SPI1_CS----------Ƭѡ
SPI1_CLK---------ʱ��
SPI1_DO--------����
SPI1_DI----------����/����ѡ��
VDDIO-----------��Դ
UART1_CTS-------��λ
ע�⣺Air202���ڵĿ����壬UART1��CTS��RTS��˿ӡ����
]]

module(...,package.seeall)

--led�������������
local pinled = pio.P0_31

--[[
��������init
����  ����ʼ��LCD����
����  ����
����ֵ����
]]
local function init()
	local para =
	{
		width = 240, --�ֱ��ʿ��ȣ�128���أ��û��������Ĳ��������޸�
		height = 320, --�ֱ��ʸ߶ȣ�160���أ��û��������Ĳ��������޸�
		bpp = 16, --λ��ȣ�������֧��16λ
		--bus = disp.BUS_SPI4LINE, --LCDר��SPI���Žӿڣ������޸�
		bus = disp.BUS_SPI,
		xoffset = 0, --X��ƫ��
		yoffset = 0, --Y��ƫ��
		freq = 52000000, --spiʱ��Ƶ�ʣ�֧��110K��13M����110000��13000000��֮�������������110000��13000000��
		hwfillcolor = 0xFFFFFF, --���ɫ����ɫ
		pinrst = pio.P0_3, --reset����λ����
		pinrs = pio.P0_12, --rs������/����ѡ������
		--��ʼ������
		--ǰ�����ֽڱ�ʾ���ͣ�0001��ʾ��ʱ��0000����0002��ʾ���0003��ʾ����
		--��ʱ���ͣ��������ֽڱ�ʾ��ʱʱ�䣨��λ���룩
		--�������ͣ��������ֽ������ֵ
		--�������ͣ��������ֽ����ݵ�ֵ
		initcmd =
		{
			--0x00010064,
			0x000200EA,
			0x00030000,
			0x000200EB,
			0x00030020,
			0x000200EC,
			0x0003003C,
			0x000200ED,
			0x000300C4,
			0x000200E8,
			0x00030048,
			0x000200E9,
			0x00030038,
			0x000200F1,
			0x00030001,
			0x000200F2,
			0x00030008,
			0x00020040,
			0x00030001,
			0x00020041,
			0x00030007,
			0x00020042,
			0x00030009,
			0x00020043,
			0x00030019,
			0x00020044,
			0x00030017,
			0x00020045,
			0x00030020,
			0x00020046,
			0x00030018,
			0x00020047,
			0x00030061,
			0x00020048,
			0x00030000,
			0x00020049,
			0x00030010,
			0x0002004A,
			0x00030017,
			0x0002004B,
			0x00030019,
			0x0002004C,
			0x00030014,
			0x00020050,
			0x0003001F,
			0x00020051,
			0x00030028,
			0x00020052,
			0x00030026,
			0x00020053,
			0x00030036,
			0x00020054,
			0x00030038,
			0x00020055,
			0x0003003E,
			0x00020056,
			0x0003001E,
			0x00020057,
			0x00030067,
			0x00020058,
			0x0003000B,
			0x00020059,
			0x00030006,
			0x0002005A,
			0x00030008,
			0x0002005B,
			0x0003000F,
			0x0002005C,
			0x0003001F,
			0x0002005D,
			0x000300CC,
			0x0002001B,
			0x0003001B,
			0x0002001A,
			0x00030001,
			0x00020024,
			0x00030060,
			0x00020025,
			0x00030058,
			0x00020023,
			0x0003006E,
			0x00020018,
			0x00030036,
			0x00020019,
			0x00030001,
			0x00020001,
			0x00030000,
			0x0002001F,
			0x00030088,
			0x0001000A,
			0x0002001F,
			0x00030080,
			0x0001000A,
			0x0002001F,
			0x00030090,
			0x0001000A,
			0x0002001F,
			0x000300D0,
			0x0001000A,
			0x00020017,
			0x00030005,
			0x00020036,
			0x00030009,
			0x00020028,
			0x00030038,
			0x00010032,
			0x00020028,
			0x0003003F,
			0x00020002,
			0x00030000,
			0x00020003,
			0x00030000,
			0x00020004,
			0x00030000,
			0x00020005,
			0x000300EF,
			0x00020006,
			0x00030000,
			0x00020007,
			0x00030000,
			0x00020008,
			0x00030001,
			0x00020009,
			0x0003003F,
			0x00020022,
			0x00010078,
		},

		addresscmd = {
			1,  -- ָ����ͣ�HX8347, CASTART1, CASTART2, CAEND1, CAEND2, RASTART1, RASTART2, RAEND1, RAEND2, GRAMWRITE
			0x02,
			0x03,
			0x04,
			0x05,
			0x06,
			0x07,
			0x08,
			0x09,
			0x22,
		},

		--��������
		sleepcmd = {
			0x00020028,
			0x000300B8,
			0x00010028,
			0x0002001F,
			0x00030089,
			0x00010028,
			0x00020028,
			0x00030004,
			0x00010028,
			0x00020019,
			0x00030000,
			0x00010005,
		},
		--��������
		wakecmd = {
			0x00020018,
			0x00030036,
			0x00020019,
			0x00030001,
			0x0002001F,
			0x00030088,
			0x00010005,
			0x0002001F,
			0x00030080,
			0x00010005,
			0x0002001F,
			0x00030090,
			0x00010005,
			0x0002001F,
			0x000300D0,
			0x00010005,
			0x00020028,
			0x00030038,
			0x00010028,
			0x00020028,
			0x0003003F,
		}
	}
	disp.init(para)
	disp.clear()
	disp.update()
end

--����SPI���ŵĵ�ѹ��
pmd.ldoset(6,pmd.LDO_VMMC)
init()

--�򿪱���
pio.pin.setdir(pio.OUTPUT,pinled)
pio.pin.setval(1,pinled)
--ʵ��ʹ��ʱ���û������Լ���lcd������Ʒ�ʽ�����ӱ�����ƴ���