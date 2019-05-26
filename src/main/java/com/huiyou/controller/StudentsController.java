package com.huiyou.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.huiyou.model.DataGridView;
import com.huiyou.model.PCAList;
import com.huiyou.model.PageOV;
import com.huiyou.model.Results;
import com.huiyou.model.Students;
import com.huiyou.service.ResultsService;
import com.huiyou.service.StudentsService;

@Controller
@RequestMapping("students")
public class StudentsController {
	@Autowired
	private StudentsService studentsService;
	@Autowired
	private ResultsService resultsService;
	
	@RequestMapping("selStudents")
	@ResponseBody
	public DataGridView selStudents(Students students, PageOV pageOV) {
		System.out.println("来自selStudents：" + students);
		pageOV.setPage((pageOV.getPage()-1)*pageOV.getLimit());
		Map<String, Object> map = new HashMap<>();
		map.put("students", students);
		map.put("page", pageOV);
		List<Object> selStudents = studentsService.selStudents(map);
		DataGridView dgv = new DataGridView();
		dgv.setData(selStudents);
		dgv.setMsg("查询成功！！");
		dgv.setCount(studentsService.count(students));
		return dgv;
	}
	
	@RequestMapping("delStudents")
	@ResponseBody
	public DataGridView delStudents(Students students) {
		System.out.println("来自delStudents：" + students);
		String ids = students.getIds();
		if (ids != "" && ids != null) {
			String ids1[] = ids.split(",");
			for (String id : ids1) {
				Integer i = Integer.parseInt(id);
				students.setId(i);
				studentsService.delStudents(students);
			}
		} else {
			studentsService.delStudents(students);
		}
		Students students1 = new Students();
		students1.setId(0);
		Map<String, Object> map = new HashMap<>();
		PageOV pageOV = new PageOV();
		map.put("students", students1);
		map.put("page", pageOV);
		List<Object> selStudents = studentsService.selStudents(map);
		DataGridView dgv = new DataGridView();
		dgv.setData(selStudents);
		dgv.setMsg("删除成功！");
		dgv.setCount(selStudents.size());
		return dgv;
	}
	
	@RequestMapping("updateStatus")
	@ResponseBody
	public void updateStatus(Students students) {
		studentsService.updateStatus(students);
	}
	
	@RequestMapping("editResults")
	public String editResults(Results results, Model model) {
		System.out.println("来自editResults：" + results);
		List<Object> selResults = resultsService.selResults(results);
		model.addAttribute("results", selResults.get(0));
		return "editResults";
	}
	
	@RequestMapping("getProvince")
	@ResponseBody
	public DataGridView getProvince(PCAList pcalist) {
		System.out.println("来自getProvince");
		List<Object> PCVList = studentsService.getProvince(pcalist);
		DataGridView dgv = new DataGridView();
		dgv.setData(PCVList);
		dgv.setMsg("查询成功省！");
		dgv.setCount(PCVList.size());
		return dgv;
	}
	
	@RequestMapping("getCity")
	@ResponseBody
	public DataGridView getCity(PCAList pcalist) {
		System.out.println("来自getCity");
		List<Object> PCVList = studentsService.getCity(pcalist);
		DataGridView dgv = new DataGridView();
		dgv.setData(PCVList);
		dgv.setMsg("查询成功市！");
		dgv.setCount(PCVList.size());
		return dgv;
	}
	
	@RequestMapping("getArea")
	@ResponseBody
	public DataGridView getArea(PCAList pcalist) {
		System.out.println("来自getArea");
		List<Object> PCVList = studentsService.getArea(pcalist);
		DataGridView dgv = new DataGridView();
		dgv.setData(PCVList);
		dgv.setMsg("查询成功区！");
		dgv.setCount(PCVList.size());
		return dgv;
	}
	
	@RequestMapping("addStudent") 
	@ResponseBody
	public void addStudent(Students students) {
		studentsService.addStudent(students);
	}
	
	@RequestMapping("editStudent")
	public String editStudent(Students students, Model model) {
		System.out.println("到编辑页面的查询参数：" + students.toString());
		PageOV pageOV = new PageOV();
		Map<String, Object> map = new HashMap<>();
		map.put("students", students);
		map.put("page", pageOV);
		System.out.println("aaaaaaaaa" + map);
		List<Object> selStudents = studentsService.selStudents(map);
		System.out.println("bbbbbbbbbbb" + selStudents);
		model.addAttribute("student", selStudents.get(0));
		System.out.println("model数据：" + model);
		return "editStudent";
	}
	
	@RequestMapping("updateStudent")
	@ResponseBody
	public Integer updateStudent(Students students) {
		System.out.println("来自updateStudent：" + students);
		studentsService.updateStudent(students);
		return 200;
	}
}
