package com.flow.coretime.users.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/elecApproval")
public class ElecApprovalController {
        @GetMapping
        public String showElecApproval(){
                return "elecApproval";
        }
}
