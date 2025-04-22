import { check, sleep } from 'k6';
import http from 'k6/http';

export let options = {
  vus: 10, // usuários simultâneos
  duration: '2m', // duração do teste
};

const token = 'SEU_TOKEN_JWT_AQUI';

export default function () {
  const url = 'https://wl14qaggrj.execute-api.us-east-1.amazonaws.com/prod/videos/upload';

  const payload = {
    files: http.file(open('./fiapvideo_p1.MOV', 'b'), 'fiapvideo_p1.MOV'),
    files: http.file(open('./fiapvideo_p2.MOV', 'b'), 'fiapvideo_p2.MOV'),
  };

  const params = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };

  const res = http.post(url, payload, params);
  check(res, {
    'status is 202': (r) => r.status === 202,
  });

  sleep(1);
}
