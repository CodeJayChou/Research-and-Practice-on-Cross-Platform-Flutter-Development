import assert from 'node:assert/strict';
import { after, before, test } from 'node:test';

import { buildApp } from '../dist/app.js';

let app;

before(async () => {
  app = await buildApp({
    logger: false,
    config: {
      nodeEnv: 'test',
      host: '127.0.0.1',
      port: 3000,
      corsOrigin: '*',
      logLevel: 'silent',
    },
  });
});

after(async () => {
  await app.close();
});

test('reports service health', async () => {
  const response = await app.inject({ method: 'GET', url: '/health' });

  assert.equal(response.statusCode, 200);
  assert.equal(response.json().status, 'ok');
});

test('returns channels in Flutter navigation order', async () => {
  const response = await app.inject({
    method: 'GET',
    url: '/api/v1/channels',
  });

  assert.equal(response.statusCode, 200);
  const payload = response.json();
  assert.equal(payload.data.length, 14);
  assert.equal(payload.data[0].id, 'live');
  assert.equal(payload.data.at(-1).id, 'recommended');
});

test('paginates channel videos with an opaque cursor', async () => {
  const firstResponse = await app.inject({
    method: 'GET',
    url: '/api/v1/channels/recommended/videos?limit=3',
  });

  assert.equal(firstResponse.statusCode, 200);
  const firstPage = firstResponse.json();
  assert.equal(firstPage.data.length, 3);
  assert.equal(firstPage.pagination.hasMore, true);
  assert.ok(firstPage.pagination.nextCursor);

  const secondResponse = await app.inject({
    method: 'GET',
    url: `/api/v1/channels/recommended/videos?limit=3&cursor=${encodeURIComponent(firstPage.pagination.nextCursor)}`,
  });
  const secondPage = secondResponse.json();

  assert.equal(secondResponse.statusCode, 200);
  assert.equal(secondPage.data.length, 3);
  assert.notEqual(secondPage.data[0].id, firstPage.data[0].id);
});

test('rejects a cursor used for another channel', async () => {
  const firstResponse = await app.inject({
    method: 'GET',
    url: '/api/v1/channels/recommended/videos?limit=2',
  });
  const cursor = firstResponse.json().pagination.nextCursor;

  const response = await app.inject({
    method: 'GET',
    url: `/api/v1/channels/music/videos?cursor=${encodeURIComponent(cursor)}`,
  });

  assert.equal(response.statusCode, 400);
  assert.equal(response.json().error.code, 'INVALID_CURSOR');
});

test('accepts a valid playback event', async () => {
  const response = await app.inject({
    method: 'POST',
    url: '/api/v1/videos/recommended-video-1/playback-events',
    payload: {
      sessionId: 'test-session',
      type: 'started',
      positionMs: 0,
    },
  });

  assert.equal(response.statusCode, 202);
  assert.equal(response.json().data.accepted, true);
  assert.ok(response.json().data.eventId);
});

test('rejects invalid playback event data', async () => {
  const response = await app.inject({
    method: 'POST',
    url: '/api/v1/videos/recommended-video-1/playback-events',
    payload: {
      sessionId: 'test-session',
      type: 'unknown',
      positionMs: -1,
    },
  });

  assert.equal(response.statusCode, 400);
  assert.equal(response.json().error.code, 'VALIDATION_ERROR');
});
