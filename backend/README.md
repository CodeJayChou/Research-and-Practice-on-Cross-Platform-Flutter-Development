# Video API

为 Flutter 视频首页提供基础频道、视频流、视频详情和播放事件接口。

## Docker 一键启动

在项目根目录执行：

```bash
docker compose -f backend/compose.yaml up --build
```

启动完成后：

- API: `http://localhost:3000`
- Swagger UI: `http://localhost:3000/docs`
- 健康检查: `http://localhost:3000/health`

停止服务：

```bash
docker compose -f backend/compose.yaml down
```

## 本地开发

```bash
cd backend
npm install
npm run dev
```

可用命令：

```bash
npm run typecheck
npm test
npm run build
npm start
```

## API

| Method | Path | Description |
| --- | --- | --- |
| GET | `/health` | 服务健康状态 |
| GET | `/api/v1/channels` | 首页频道列表 |
| GET | `/api/v1/channels/:channelId/videos` | 按频道游标分页获取视频 |
| GET | `/api/v1/videos/:videoId` | 获取视频详情 |
| POST | `/api/v1/videos/:videoId/playback-events` | 上报播放行为 |

分页示例：

```bash
curl "http://localhost:3000/api/v1/channels/recommended/videos?limit=5"
```

播放事件示例：

```bash
curl -X POST "http://localhost:3000/api/v1/videos/recommended-video-1/playback-events" \
  -H "Content-Type: application/json" \
  -d '{"sessionId":"session-001","type":"started","positionMs":0}'
```

当前使用有容量上限的内存仓储，适合 Flutter 联调。后续可以在不修改路由契约的情况下替换为 PostgreSQL、Redis 和对象存储/CDN。
