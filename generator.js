function sleep(msec) {
  return new Promise(function(resolve) {
    setTimeout(function(){ resolve("sleep: " + msec) }, msec);
  });
}

function asyncFunc(genFunc){
  const itr = genFunc();
  const runner = function(arg){
    let result = itr.next(arg);
    if(result.done){
      return result.value;
    }else{
      return Promise.resolve(result.value).then(runner);
    }
  }
  return runner();
}

asyncFunc(function* (){
  const res1 = yield sleep(3000);
  console.log(res1);

  const res2 = yield sleep(2000);
  console.log(res2);

  const res3 = yield sleep(1000);
  console.log(res3);

  return res3
});
