function sleep(msec) {
  return new Promise(function(resolve) {
    setTimeout(function(){ resolve("sleep: " + msec) }, msec);
  });
}

async function sleeeeeeeep(){
  const res1 = await sleep(3000);
  console.log(res1);

  const res2 = await sleep(2000);
  console.log(res2);

  const res3 = await sleep(1000);
  console.log(res3);

  return res3
}

sleeeeeeeep();
