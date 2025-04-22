import { check, sleep } from "k6";
import http from "k6/http";

// Configuração do teste
export let options = {
  vus: 3,
  duration: "60s",
};

const token = __ENV.TOKEN;

// Carrega o arquivo no escopo global (obrigatório)
const file = http.file(open("./fiapvideo.MOV", "b"), "fiapvideo.MOV", "video/quicktime");

export default function () {
  const url = "https://wl14qaggrj.execute-api.us-east-1.amazonaws.com/prod/videos/upload";

  const formData = {
    files: file,
  };

  const params = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };

  const res = http.post(url, formData, params);

  check(res, {
    "status is 202": (r) => r.status === 202,
  });

  sleep(10);
}
