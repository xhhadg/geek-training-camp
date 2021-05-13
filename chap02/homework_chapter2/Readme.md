备忘：命令
python setup.py install
python main.py

运行结果：
tm_dict0.png	原版函数target_mean_v3()							耗时：0.00299	结果正确
tm_dict1.png	dict的key value改为int           					耗时：0.00199	结果正确
tm_dict2.png	改为cnp.ndarray[int, ndim=1, mode='fortran'] y      耗时：0.00099	结果正确
tm_unordered_map.png	再改为unordered_map      					耗时：0.00099	结果基本正确
以上结果100000行观测皆能在1s内跑完

思考(希望助教老师能够解答一下)：
1.为什么每次在error_tm.pyx中python setup.py install能成功，但是一旦在main.py中使用tm.target_mean_v4()
就在cdef cnp.ndarray[int, ndim=1, mode='fortran'] x = np.asfortranarray(data[x_name], dtype=np.int32)
这一句报错：ValueError: Buffer dtype mismatch, expected 'int' but got 'double'
但是将target_mean_v3()与target_mean_v4()分别写到两个.pyx文件中就不报错了？
2.为什么有时候改完.pyx文件后，删掉python install后出现的cpp和build文件后重新python install还是会显示改之前实现方法的运行时间？
3.为什么在改为unordered_map后对比dict速度并没有明显提升？


原来是5000 运行的