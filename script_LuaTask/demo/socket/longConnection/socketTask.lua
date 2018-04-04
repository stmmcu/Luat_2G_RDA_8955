--- 模块功能：socket长连接功能测试.
-- 与服务器连接成功后
--
-- 每隔10秒钟发送一次"heart data\r\n"字符串到服务器
--
-- 每隔20秒钟发送一次"location data\r\n"字符串到服务器
--
-- 与服务器断开连接后，会自动重连
-- @author openLuat
-- @module socketLongConnection.testSocket1
-- @license MIT
-- @copyright openLuat
-- @release 2018.03.27

module(...,package.seeall)

require"socket"
require"socketOutMsg"
require"socketInMsg"

local ready = false

--- socket连接是否处于激活状态
-- @return 激活状态返回true，非激活状态返回false
-- @usage socketTask.isReady()
function isReady()
    return ready
end

--启动socket客户端任务
sys.taskInit(
    function()
        while true do
            --等待网络环境准备就绪
            while not socket.isReady() do sys.waitUntil("IP_READY_IND") end

            --创建一个socket tcp客户端
            local socketClient = socket.tcp()
            --阻塞执行socket connect动作，直至成功
            while not socketClient:connect("36.7.87.100","6500") do
                sys.wait(2000)
            end
            
            ready = true
            
            socketOutMsg.init()
            --循环处理接收和发送的数据
            while true do
                if not socketInMsg.proc(socketClient) then log.error("socketTask.socketInMsg.proc error") break end
                if not socketOutMsg.proc(socketClient) then log.error("socketTask.socketOutMsg proc error") break end
            end
            socketOutMsg.unInit()

            ready = false
            --断开socket连接
            socketClient:close()
        end
    end
)